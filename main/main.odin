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
    // newHeader:= data.make_new_db_header()

    // serializedHeader:= codec.serialize_db_header(newHeader)
    // fmt.println("Serialized Header: ", serializedHeader)

    // deserializedHeader:= codec.deserialize_db_header(serializedHeader)
    // fmt.println("Deserialized Header: ", deserializedHeader)



    //Example of creating a record and appending a field then serializing said record
    // record: ^lib.Record
    // record = data.make_new_record("example")
    // arr:= make([dynamic]lib.Field)

    // age:u64=30
    // ageBytes:=codec.serialize_u64(age)
    // field:= data.make_new_field("user_age" ,lib.CORE_TYPE_INTEGER, ageBytes[:])
    // append(&arr, field)
    // record = data.append_field_to_record(record, field)
    // byteCode:=  codec.serialize_record(record^, arr)

    // fmt.println("Recod ByteCode: ", byteCode)



    //Deserializing a serialized field
    age:u64=30
    ageBytes:=codec.serialize_u64(age)
    field:= data.make_new_field("usesadadr_age" ,lib.CORE_TYPE_INTEGER, ageBytes[:])
    // fmt.println("Field: ", field)
    serializedField:= codec.serialize_field(field)
    fmt.println("Field: ", serializedField)
    codec.deserialize_to_field(serializedField)

}

