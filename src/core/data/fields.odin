package data

import "core:fmt"
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
* File Description: Contains logic for interacting with ChunkDB Record Fields
*************************************************************************/


make_new_field :: proc(name: string, type: u8, value: []u8) -> lib.Field {
    return lib.Field{
        name = transmute([]u8)name,
        nameLength = transmute([1]u8)u8(len(name)),
        type = type,
        value = value,
        valueLength = transmute([4]u8)u32(len(value))
    }
}