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
fn main():
    # Create Person instance 'a'
    let person_a=Person('isack', 27)

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

    #after move person_a info to person_c you can no longer access person_a info.
    print(person_a.name, person_a.age) # it gives error: use of uninitialized value 'person_a'
