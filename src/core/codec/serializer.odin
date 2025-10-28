package codec

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

// ????
serialize_u16_big_E :: proc(val: u16) -> [2]u8{
    result:[2]u8
    endian.put_u16(result[:], .Big, val)
    return result
}

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

serialize_db_header :: proc(header: lib.DatabaseHeader ) -> []u8{
    result: [dynamic]u8
    buf: u8 = ---

    //Append first 10 bytes for magic number
    append(&result, ..header.magicNumber) //[67, 72, 85, 78, 75, 68, 66, 95, 86, 49]

    //append 4 bytes for version
    for buf in header.version{
        append(&result, buf) // [1, 0, 0, 0,]
    }

    //append bytes for total capacity
    for buf in header.totalCapacity{
        append(&result, buf)
    }

    //TODO: missing bytes used AND  sizePreAllocated

    //append 8 bytes for nanosecond time created
    for buf in header.createdAt{
        append(&result, buf)
    }

    // append 8 bytes for nanosecond time created
    for buf in header.lastModifiedAt{
        append(&result, buf)
    }

    return result[:]
}

//Helper that gets the prefix of a field name and returns the 2 byte representation
// TODO: Move me somewhere else???
@(require_results)
get_field_name_prefix :: proc(val: string) ->[2]u8 {
    result := u16(len(val))
    return serialize_u16(result)
}

@(require_results)
serialize_field :: proc(f: lib.Field) -> []u8{
    result: [dynamic]u8

    //append the 2 name length bytes prefix
    nameLenBytes := serialize_u16(f.nameLength)
    append(&result, nameLenBytes[0], nameLenBytes[1])

     //and the name bytes representation  itself
     append(&result, ..f.name)

    //add the type byte if its an array make sure to user proper
    typeByte := serialize_u8(f.type)
    append(&result, typeByte[0])

     //add 4 value len bytes
     valLenBytes := serialize_u32(f.valueLength)
     append(&result, valLenBytes[0], valLenBytes[1], valLenBytes[2], valLenBytes[3])

    // Add value bytes representation
    append(&result, ..f.value)

    return result[:]
}
