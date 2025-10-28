package main

import "core:os"
import "core:fmt"
import "../src/core/codec"
import "../src/core/data"
import lib"../src/library"
/*************************************************************************
* Author: Marshall A Burns
* GitHub: @SchoolyB
* Date: 27 October 2025
* Copyright 2025-Present Marshall A. Burns
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
* File Description: Main entry point
*************************************************************************/
main :: proc() {

    // //Example field creation
    // age:u64=30
    // ageBytes:=codec.serialize_u64(age)
    // field:= data.make_new_field("user_age" ,lib.CORE_TYPE_INTEGER, ageBytes[:])
    // fmt.println("Created Byte Code of Field: " ,field)


    // //Example string serialization
    // magicNumBytes:= codec.serialize_string(lib.MAGIC_NUMBER)
    // fmt.println(magicNumBytes)


    // //Header creation(in mem), serialization, write to disk
    // header:= data.make_new_db_header()
    // make_db_file(lib.EXAMPLE_DB_PATH)
    // data.append_db_header(header, lib.EXAMPLE_DB_PATH)

    //Header serialization, deserialization
    newHeader:= data.make_new_db_header()

    serializedHeader:= codec.serialize_db_header(newHeader)
    fmt.println("Serialized Header: ", serializedHeader)

    deserializedHeader:= codec.deserialize_db_header(serializedHeader)
    fmt.println("Deserialized Header: ", deserializedHeader)
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
