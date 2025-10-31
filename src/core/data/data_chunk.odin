package data

import "core:fmt"
import lib"../../library"
/*************************************************************************
* Author: Marshall A Burns
* GitHub: @SchoolyB
* Date: 31 October 2025
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
* File Description: Contains logic for creating and interacting with Chunks
*************************************************************************/

make_new_chunk_directory :: proc() -> lib.ChunkDirectoy{
    dir: lib.ChunkDirectoy
    dir.chunks = make([dynamic]lib.DataChunk)

    return dir
}


make_new_data_chunk :: proc(previousChunk: ^lib.DataChunk) -> (lib.DataChunk) {
    chunk: lib.DataChunk

    chunk.header.id = 0 //TODO: need to get accurate chunk count
    chunk.header.nextChunk = previousChunk
    chunk.header.usedBytes = 0
    chunk.header.type = .DATA_CHUNK
    chunk.records = make([dynamic]lib.Record)

    return chunk
}

append_record_to_data_chunk ::proc(c: ^lib.DataChunk, r: lib.Record)-> lib.DataChunk{
    append(&c.records, r)

    return c
}

append_records_to_data_chunk :: proc(c: ^lib.DataChunk, records:[dynamic]lib.Record) -> lib.DataChunk{
    for r in records{
        append_record_to_data_chunk(c.records, r)
    }

    return r
}

// get_previous_chunk :: proc(b:[]u8) ->^lib.Chunk{


// }