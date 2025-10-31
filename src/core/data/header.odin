package data

import "core:os"
import "core:fmt"
import "core:time"
import "../codec"
import lib"../../library"
/*************************************************************************
* Author: Marshall A Burns
* GitHub: @SchoolyB
* Date: 28 October 2025
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
* File Description: Contains logic for creating and interacting with ChunkDB file headers
*************************************************************************/

@(require_results)
make_new_db_header ::proc () -> lib.DatabaseHeader {
    header:lib.DatabaseHeader

    currentTime:= time.now()
    currentNanoSec:= transmute(u64)currentTime._nsec

    header.magicNumber = header.magicNumber
    header.version = lib.VERSION
    header.totalCapacity = lib.DEFAULT_DB_CAPACITY
    header.createdAt = currentNanoSec
    header.lastModifiedAt = currentNanoSec
    //TODO: Once allocation stuff is done continue making header

    return header
}


append_db_header :: proc(h: lib.DatabaseHeader, path: string) {
    file, openErr := os.open(path, os.O_APPEND | os.O_WRONLY, 0o666)
    if openErr != os.ERROR_NONE {
        fmt.println("Error opening file:", openErr)
        return
    }

    defer os.close(file)

    serializedHeader := codec.serialize_db_header(h)

    bytesWritten, err := os.write(file, serializedHeader)
    if err != nil {
        fmt.println("Write error:", err)
    } else {
        fmt.println("Bytes written:", bytesWritten)
    }
}