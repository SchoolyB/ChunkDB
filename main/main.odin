package main
import "core:fmt"
import lib"../src/library"
import "../src/core/codec"
import "../src/core/data"

main :: proc() {

    //Example field creation
    age:u64=30
    ageBytes:=codec.serialize_u64(age)
    field:= data.make_new_field("user_age" ,lib.CORE_TYPE_INTEGER, ageBytes[:])
    fmt.println("Created Byte Code of Field: " ,field)
}