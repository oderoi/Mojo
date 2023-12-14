from random import rand
from memory import memset, memset_zero
from memory.unsafe import DTypePointer, Pointer
import benchmark

alias type=DType.float64

struct Matrix:
    var data: DTypePointer[type]
    var rows: Int
    var cols: Int

    #initisalize zeroing all values
    fn __init__(inout self, rows: Int, cols: Int):
        self.data = DTypePointer[type].alloc(rows * cols)
        memset_zero(self.data, rows*cols)
        self.rows = rows
        self.cols = cols

    #initialize taking a pointer, don't set any elements    
    fn __init__(inout self, rows: Int, cols: Int , data: DTypePointer[DType.float64]):
        self.data=data
        self.cols=cols
        self.rows=rows

    #Initialize with random values

    @staticmethod
    fn rand(rows: Int, cols: Int)-> Self:
        let data = DTypePointer[type].alloc(rows * cols)
        rand(data, rows*cols)
        return Self(rows,  cols, data)

    fn __getitem__(self, y: Int, x: Int)->Float64:
        return self.load[1](y, x)

    fn __setitem__(self, y: Int, x: Int, val: Float64):
        return self.store[1](y,  x, val)

    fn load[nelts: Int](self, y: Int, x: Int) -> SIMD[DType.float64, nelts]:
        return self.data.simd_load[nelts](y * self.cols + x)

    fn store[nelts: Int](self, y: Int, x: Int, val: SIMD[DType.float64, nelts]):
        return self.data.simd_store[nelts](y * self.cols + x, val)

    fn __del__(owned self):
        self.data.free()

   
    fn print(self):
        print_no_newline("[")
        for i in range(self.rows*self.cols):
            if i > 0:
                print_no_newline(", ")
            print_no_newline(self.data.load(i))
        print("]")
        
# Note that C, A, and B have types.
fn matmul_naive(C: Matrix, A: Matrix, B: Matrix):
    for m in range(C.rows):
        for k in range(A.cols):
            for n in range(C.cols):
                C[m, n] += A[m, k] * B[k, n]



fn main():
    alias M = 1024
    alias N = 1024
    alias K = 1024

    @always_inline
    fn bench[
        func: fn (Matrix, Matrix, Matrix) -> None](base_gflops: Float64):
        var C = Matrix(M, N)
        var A = Matrix.rand(M, K)
        var B = Matrix.rand(K, N)

        @always_inline
        @parameter
        fn test_fn():
            _ = func(C, A, B)

        let secs = benchmark.run[test_fn](max_runtime_secs=1).mean()
        # Prevent the matrices from being freed before the benchmark run
        A.data.free()
        B.data.free()
        C.data.free()
        let gflops = ((2 * M * N * K) / secs) / 1e9
        #let speedup: Float64 = gflops / base_gflops
        print(gflops, "GFLOP/s")
        #print(gflops, "GFLOP/s, a", speedup, "x speedup over Python")

    bench[matmul_naive](Float64)