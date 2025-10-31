package codec

import "core:fmt"
import lib"../../library"
import "core:encoding/endian"
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
* File Description: Contains logic for serializing in memory data into valid ChunkDB data(bytecode)
*************************************************************************/
@(require_results)
serialize_u64 :: proc(val: u64) -> [8]u8{
    return transmute([8]u8)val
}

@(require_results)
serialize_u32 :: proc(val: u32) -> [4]u8{
    return transmute([4]u8)val
}

@(require_results)
serialize_u16 :: proc (val:u16) -> [2]u8{
    return transmute([2]u8)val
}

@(require_results)
serialize_u8 :: proc(val: u8) -> [1]u8 {
    return transmute([1]u8)val
}

@(require_results)
serialize_f64 :: proc(val: f64) -> [8]u8{
    return transmute([8]u8)val
}

@(require_results)
serialize_string:: proc(val: string) -> []u8{
    return transmute([]u8)val
}

@(require_results)
serialize_db_header :: proc(header: lib.DatabaseHeader ) -> []u8{
    result: [dynamic]u8
    b: u8 = ---

    //Append first 10 bytes for magic number
    for b in header.magicNumber{
        append(&result, b) //[67, 72, 85, 78, 75, 68, 66, 95, 86, 49]
    }

    //append 4 bytes for version
    versionBytes:= serialize_u32(header.version)
    append(&result, ..versionBytes[:]) // [1, 0, 0, 0,]

    //append bytes for total capacity
    capacityBytes:= serialize_u32(header.totalCapacity)
    append(&result, ..capacityBytes[:])

    //TODO: missing bytes used AND  sizePreAllocated

    //append 8 bytes for nanosecond time created
    createdAtBytes:= serialize_u64(header.createdAt)
    append(&result, ..createdAtBytes[:])

    // append 8 bytes for nanosecond time created
    lastModifiedBytes := serialize_u64(header.lastModifiedAt)
    append(&result, ..lastModifiedBytes[:])

    return result[:]
}

@(require_results)
serialize_data_chunk :: proc(chunk: lib.DataChunk)->[]u8{
    result: [dynamic]u8

    id:= serialize_u64(chunk.header.id)
    append(&result, ..id[:])

    size:= serialize_u32(lib.DEFAULT_CHUNK_ALLOCATION_SIZE)
    if chunk.header.sizePreAllocated == 0{
        append(&result, ..size[:])
    }else{
        size = serialize_u32(chunk.header.sizePreAllocated)
        append(&result, ..size[:])
    }

    //This helps make deserializtion easier trust me
    recordCount := serialize_u32(u32(len(chunk.records)))
    append(&result, ..recordCount[:])

    record:lib.Record
    for r in chunk.records{
        serializedRecord := serialize_record(r)
        append(&result, ..serializedRecord[:])
    }

    usedBytes:=serialize_u16(chunk.header.usedBytes)
    append(&result, ..usedBytes[:])

    return result[:]
}

@(require_results)
serialize_record ::proc(record: lib.Record)-> []u8 {
    result: [dynamic]u8
    serializedField:[]u8

    id:= serialize_u8(record.id)
    append(&result,  id[0])

    // Add field count to make deserialization easier
    fieldCount := serialize_u32(u32(len(record.fields)))
    append(&result, ..fieldCount[:])

    for f in record.fields {
        serializedField, _ = serialize_field(f)
        append(&result, ..serializedField)
    }

    return result[:]
}

//Serializes the passed in field into byte code format. Returns an array of bytes and the number of bytes the field consumed
@(require_results)
serialize_field :: proc(f: lib.Field) -> ([]u8, int){
    result: [dynamic]u8
    b:u8=---

    //append the SINGLE name length byte prefix
    nameLenByte := serialize_u8(f.nameLength)
    append(&result, ..nameLenByte[:])

     //and the name bytes representation  itself
     nameBytes:= serialize_string(f.name)
     append(&result, ..nameBytes[:])

    //add the type byte if its an array make sure to user proper
    typeByte:= serialize_u8(f.type)
    append(&result, ..typeByte[:])


     //add 4 value len bytes
     valLenBytes:= serialize_u32(f.valueLength)
     append(&result, ..valLenBytes[:])

    // Add value bytes representation
    append(&result, ..f.value)

    return result[:], len(result)
}

//Helper that gets the prefix of a field name and returns the 2 byte representation
// TODO: Move me somewhere else???
@(require_results)
get_field_name_prefix :: proc(val: string) ->[2]u8 {
    result := u16(len(val))
    return serialize_u16(result)
}
