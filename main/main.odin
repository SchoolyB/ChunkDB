package main

import "core:os"
import "core:fmt"
import "../src/core/codec"
import "../src/core/data"
import lib"../src/library"

main :: proc() {

    //Example field creation
    // age:u64=30
    // ageBytes:=codec.serialize_u64(age)
    // field:= data.make_new_field("user_age" ,lib.CORE_TYPE_INTEGER, ageBytes[:])
    // fmt.println("Created Byte Code of Field: " ,field)


    //Example string serialization
    // magicNumBytes:= codec.serialize_string(lib.MAGIC_NUMBER)
    // fmt.println(magicNumBytes)


    //Header creation(in mem), serialization, write to disk
    header:= data.make_new_db_header()
    make_db_file(lib.EXAMPLE_DB_PATH)
    data.append_db_header(header, lib.EXAMPLE_DB_PATH)
}

make_db_file :: proc(path: string) -> bool {
    file, openErr := os.open(path, os.O_CREATE | os.O_RDWR, 0o777)
    if openErr != os.ERROR_NONE {
        fmt.println("Error creating file:", openErr)
        return false
    }
    defer os.close(file)

    fmt.println("File created successfully")
    return true
}
