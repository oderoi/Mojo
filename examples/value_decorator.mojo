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


fn main():
    let me=Person('isack', 27)

    print("my name is : ", me.name, "i'm", me.age, "years old")