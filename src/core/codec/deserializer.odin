package codec

import "core:fmt"
import "core:bytes"
import "core:slice"
import "core:path/filepath"
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
      copy(header.magicNumber[:], b[offset:offset+10]) //Starting at 0 get 10 bytes [0,1,2,3,4,5,6,7,8,9]
      offset += 10

      //next 4 are version
      versionBytes: [4]u8
      free(&versionBytes)
      copy(versionBytes[:], b[offset:offset+4]) //starting at 10 get next 4 bytes [10,11,12,13]
      header.version = deserialize_to_u32(versionBytes)
      offset += 4

      // next 4 are total file capacity
      capacityBytes: [4]u8
      copy(capacityBytes[:], b[offset:offset+4])
      header.totalCapacity = deserialize_to_u32(capacityBytes)
      offset += 4

      //next 8 are creattion time in nanoseconds
      createdAtBytes: [8]u8
      copy(createdAtBytes[:], b[offset:offset+8])
      header.createdAt = deserialize_to_u64(createdAtBytes)
      offset += 8

      //next 8 are last modified time in nanoseconds
      modifiedAtBytes: [8]u8
      copy(modifiedAtBytes[:], b[offset:offset+8])
      header.lastModifiedAt = deserialize_to_u64(modifiedAtBytes)
      offset += 8

      return header
  }

  //Fucking voodoo man
  deserialize_to_field :: proc(b:[]u8) -> lib.Field{
      field: lib.Field

      offset:= 0

        // grab the first byte which is always the field's name len prefix
       field.nameLength = b[offset]
       offset += 1

       //Jump to second byte which will ALWAYS be the start of the field's name
       fieldNameLenAsInt := int(field.nameLength)
       field.name = deserialize_to_string(b[1:1+fieldNameLenAsInt])
       offset += fieldNameLenAsInt

       //grab the next byte which will always be the field's 'type' byte
       field.type = b[offset]
       offset += 1

        //read the value length (should be 4 bytes since value len struct stores as 'u32')
        // to determine how many bytes the actual value occupies
       valueLengthBytes: [4]u8
       copy(valueLengthBytes[:], b[offset:offset + 4])
       field.valueLength = deserialize_to_u32(valueLengthBytes)
       offset += size_of(field.valueLength)

        //Since We know the length of the value,
        // Make a new slice of that exact size and copy to it
        valueBytes := make([]u8, field.valueLength)
        copy(valueBytes[:], b[offset:offset + int(field.valueLength)])
        field.value = valueBytes

      return field
  }

  //Shoutout to the intern Claude the G.O.A.T
  @(require_results)
  deserialize_record :: proc(b:[]u8) -> lib.Record{
    record: lib.Record
    fields:=make([dynamic]lib.Field)

    offset:= 0

    // First byte is always the record ID
    record.id = b[offset]
    offset += 1

    //This loop essentiall continues deserializing fields until all bytes are consumed
    for offset < len(b) {

        //1 byte for name len
        fieldNameLen:= int(b[offset])

        //Total field size is mostly unknown because 'name' and 'value' can grow or shrink
        // but nameLen, is always 1 byte, type is always 1 byte and valueLen is always 4 bytes
        // read value len(4 bytes) after the 'type' byte
        valueLengthOffset:= offset + 1 + fieldNameLen + 1

        if valueLengthOffset + 4 > len(b) {
            break
        }

        //get the value len
        valueLengthBytes: [4]u8
        copy(valueLengthBytes[:], b[valueLengthOffset:valueLengthOffset + 4])
        valueLength := deserialize_to_u32(valueLengthBytes)

        //get total field size
        fieldSize := 1 + fieldNameLen + 1 + 4 + int(valueLength)

        if offset + fieldSize > len(b) {
            break
        }

        f := deserialize_to_field(b[offset:offset + fieldSize])
        append(&fields, f)

        //move offset to next field
        offset += fieldSize
    }

    record.fields = fields

    return record
  }