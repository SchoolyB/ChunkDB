package library

import "core:os"
import "core:fmt"
/*************************************************************************
* Author: Marshall A Burns
* GitHub: @SchoolyB
* Date: 29 October 2025
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
* File Description: Common helper procedures and what not
*************************************************************************/

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

// Defaults to creating a .chunky file of 50kb
make_db_with_explicit_size :: proc(path: string, size:u32= DEFAULT_DB_CAPACITY){
    file, openError := os.open(path, os.O_CREATE | os.O_WRONLY | os.O_TRUNC, 0o644)
    if openError != os.ERROR_NONE {
        fmt.println("Error opening file:", openError)
        return
    }
    defer os.close(file)

    // Seek to size-1 and write a byte
    _, seekError := os.seek(file, i64(size - 1), os.SEEK_SET)
    if seekError != os.ERROR_NONE {
        fmt.println("Error seeking:", seekError)
        return
    }

    byteToWrite: []u8 = {0}
    _, writeError := os.write(file, byteToWrite)
    if writeError != os.ERROR_NONE {
        fmt.println("Error writing:", writeError)
        return
    }

    fmt.println("Successfully made DB of size: ", size)
}
