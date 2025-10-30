package codec

import "core:fmt"
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

deserialize_db_header :: proc(b: []u8) -> lib.DatabaseHeader {
      header: lib.DatabaseHeader

    // min size of the file header will be 58: 10 + 4 + 4 + 8 + 8 + sizePreAllocated + usedBytes
      if len(b) < 34 { //TODO: Set this to 34 for the time being until I work on allocations. When done set to 58
          return header
      }

      offset := 0

      //First 10 bytes are magic nums
      header.magicNumber = b[offset:offset+10] //Starting at 0 get 10 bytes [0,1,2,3,4,5,6,7,8,9]
      offset += 10

      //next 4 are version
      copy(header.version[:], b[offset:offset+4]) //starting at 10 get next 4 bytes [10,11,12,13]
      offset += 4

      // next 4 are total file capacity
      copy(header.totalCapacity[:], b[offset:offset+4])
      offset += 4

      //next 8 are creattion time in nanoseconds
      copy(header.createdAt[:], b[offset:offset+8])
      offset += 8

      //next 8 are last modified time in nanoseconds
      copy(header.lastModifiedAt[:], b[offset:offset+8])
      offset += 8

      return header
  }

  deserialize_to_field :: proc(b:[]u8) -> lib.Field{
      field: lib.Field

      offset:= 0

        // grab the first byte
       copy(field.nameLength[:], b[offset:offset+1])
       offset += 1

       //Jump to second byte which will ALWAYS be the start of the field's name
       //Fucking VOODOO
       firstByteVal:int
       for v in field.nameLength{
           firstByteVal = int(v)
       }

       field.name = b[1:1+firstByteVal]
       fmt.println(field.name)

       //TODO: Continue



      return field
  }