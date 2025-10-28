package codec

import "core:bytes"
import "core:slice"
import lib"../../library"
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
* File Description: Contains logic for ChunkDB data(bytecode) deserialization.
*************************************************************************/

@(require_results)
deserialize_to_u64 :: proc(val: [8]u8) -> u64{
    return transmute(u64)val
}

@(require_results)
deserialize_to_u32 :: proc(val:[4]u8) -> u32 {
    return transmute(u32)val
}

@(require_results)
deserialize_to_u16 :: proc (val:[2]u8) -> u16{
    return transmute(u16)val

}
@(require_results)
deserialize_to_u8 :: proc(val:[1]u8) -> u8 {
    return transmute(u8)val
}

@(require_results)
deserialize_to_f64 :: proc(val:[8]u8) -> f64{
    return transmute(f64)val
}

@(require_results)
deserialize_to_string :: proc(val: []u8) -> string{
    return transmute(string)val
}


deserialize_db_header ::proc(b:[]u8) -> lib.DatabaseHeader{
    header: lib.DatabaseHeader

    if len(b) > 0{
        arr:[dynamic]u8
        nByte:u8

        //first 10 bytes are going to always be magic number
        magicNum :[10]u8= {b[0], b[1], b[2],b[3],b[4],b[5],b[6],b[7],b[8], b[9]}
        for n in magicNum {
            nByte =  deserialize_to_u8(n)
            append(&arr, nByte)
        }

        // next

        header.magicNumber = arr[:]


    }

    return header
}