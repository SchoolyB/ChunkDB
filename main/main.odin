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


    //Header creation(in mem), serialization, write to disk
    // header:= data.make_new_db_header()
    // serializdHeader:= codec.serialize_db_header(header)
    // deserializedHeader:= codec.deserialize_db_header(serializdHeader)
    // lib.make_db_file(lib.EXAMPLE_DB_PATH)
    // data.append_db_header(header, lib.EXAMPLE_DB_PATH)

    //Header serialization, deserialization
    // newHeader:= data.make_new_db_header()

    // serializedHeader:= codec.serialize_db_header(newHeader)
    // fmt.println("Serialized Header: ", serializedHeader)

    // deserializedHeader:= codec.deserialize_db_header(serializedHeader)
    // fmt.println("Deserialized Header: ", deserializedHeader)



    //Example of creating a record and appending  2 fields then serializing said record
    record: ^lib.Record

    record = data.make_new_record("example")
    arr:= make([dynamic]lib.Field)
    byteArr:= make([dynamic]u8)

    age:u64=30
    ageBytes:=codec.serialize_u64(age)
    field:= data.make_new_field("user_age" ,lib.CORE_TYPE_INTEGER, ageBytes[:])
    anotherField:= data.make_new_field("favorite_number" ,lib.CORE_TYPE_INTEGER, ageBytes[:])

    serializedField, bytesConsumed:= codec.serialize_field(field)
    append(&arr, field)

    anotherSerializedField, moreBytesConsumed:= codec.serialize_field(anotherField)
    append(&arr, anotherField)

    fmt.println("Serialized Field and Bytes Consumed: ",serializedField,bytesConsumed)

    record= data.append_fields_to_record(record,arr)

    serializedRecord:=  codec.serialize_record(record^, arr)
    fmt.println("Serialized Record: ", serializedRecord)

    // //Example of record deserialization
    deserializedRecord:= codec.deserialize_record(serializedRecord)
    fmt.println("Deserialized Record: ",deserializedRecord)

    //Deserializing a serialized field
    // age:u64=30
    // ageBytes:=codec.serialize_u64(age)
    // field:= data.make_new_field("user_age" ,lib.CORE_TYPE_INTEGER, ageBytes[:])
    // serializedField:= codec.serialize_field(field)
    // fmt.println("Serialized Field: ", serializedField)
    // deserializedField:= codec.deserialize_to_field(serializedField)
    // fmt.println("deserialized Field: ", deserializedField)


}

