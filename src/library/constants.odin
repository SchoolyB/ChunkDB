package library
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
* File Description: Contains MOST constants used throughout codebase
*************************************************************************/
EXAMPLE_DB_PATH :: "./example.chunky"

//DB header shit
MAGIC_NUMBER :string: "CHUNKDB_V1"
VERSION :u32: 1
DEFAULT_DB_CAPACITY :u64: 512_000 //500kb this includes pre-allocated chunks
MAX_DB_CAPACITY :u64: 5_242_880 //5mb. User cannot allocate anymore


//Reocrd Field Type constants
CORE_TYPE_NULL :u8: 00
CORE_TYPE_CHAR :u8: 01
CORE_TYPE_INTEGER :u8: 02
CORE_TYPE_FLOAT :u8: 03
CORE_TYPE_STRING :u8: 04
CORE_TYPE_DATE :u8: 05
CORE_TYPE_UUID :u8: 06
CORE_TYPE_ARRAY :u8: 07
    //field subtypes are only applied if the core type is an array...
    SUB_TYPE_CHAR_ARRAY :u8: 70
    SUB_TYPE_INTEGER_ARRAY :u8: 71
    SUB_TYPE_FLOAT_ARRAY :u8: 72
    SUB_TYPE_STRING_ARRAY :u8: 73
    SUB_TYPE_DATE_ARRAY :u8: 74
    SUB_TYPE_UUID_ARRAY :u8: 75
