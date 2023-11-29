"""
@value decorator
================

Most of "struct" are simple aggregations/combination of other types. 
We don't have to write a boilerplate for all types.
Now to achive that, Mojo comes with @value decorator for struct that synthesizes a lot of boilerplate for you.

@value decorator help us to handle __init__, __moveinit__
and __copyinit__ for us.

The @value decorator takes a look at the fields of your type, and genetates some memebrs that are missing

Consider a simple struct like the following:

"""

@value
struct Person:
    var name: String
    var age: Int


# Now let run Person struct using main function and perform __init__, __copyinit__ and __moveinit__
# Now let us implement the person struct of what @value decoretor write for us when we pass @value decorator on the struct.



struct Persons:
    var name: String
    var age: Int

    fn __init__(inout self, owned name: String, age: Int):
        self.name=name
        self.age=age

    fn __copyinit__(inout self, existing: Self):
        self.name = existing.name
        self.age = existing.age

    fn __moveinit__(inout self, owned existing: Self):
        self.name = existing.name
        self.age = existing.age


"""
To run this we write a main() fn and use weither struct Person to run  "struct Person" or use struct Persons to run "struct Persons"
"""
# Now let run Person struct using main function and perform __init__, __copyinit__ and __moveinit__
fn main():
    # Create Person instance 'a'
    let person_a=Persons('isack', 27)

    # print the person_a data
    print( person_a.name, person_a.age)

    # copy person_a to person_b
    let person_b = person_a

    # print the person_a data
    print( person_b.name, person_b.age)

    # Move let us move person_a to person_c
    let person_c=person_a^

    # print the person_c data
    print( person_c.name, person_c.age)

    # after move person_a info to person_c you can no longer access person_a info.
    # print(person_a.name, person_a.age) # it gives error: use of uninitialized value 'person_a'

"""
Now when you add @value decorator, mojo simply synthesizes each of these speacial methods
(__init__, __copy__  and  __move__) only when it doesn't exist. We can override the bihaviors 
if we want by defining our own versions.

The arguments to__init__ are all passed as owned arguments since the struct takes ownership and 
stores the value. This is a useful micro-optimization and enables the use of move-only types. 
Trivial types like Int are also passed as owned values, but since that doesn’t mean anything for.
 them, we elide the marker and the transfer operator (^) for clarity.
"""