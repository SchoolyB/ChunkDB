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
