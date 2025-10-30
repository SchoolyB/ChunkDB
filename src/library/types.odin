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
* File Description: Contains Structs, Enums, and Maps used throughout codebase
*************************************************************************/
DatabaseHeader :: struct{
    magicNumber: [10]u8, //versioning like: "CHUNKDB_V1"
    version: u32,
    sizePreAllocated: u32, // Size of all pre-allocated overhead (headers, indexes, etc.) DOES NOT include data chunks
    totalCapacity: u32,
    usedBytes: u32,
    createdAt: u64,
    lastModifiedAt: u64
}

IndexFile:: struct {
    fieldNameOffets: [dynamic]map[string]int
}

ChunkHeader  :: struct {
    id: u64,
    type: u64,
    usedBytes: u16,
    nextChunk: u64
}

DataChunk :: struct {
    header: ChunkHeader,
    sizePreAllocated: u8,
    records: [dynamic]Record
}

// Represents a single field within a record (name-type-value triple)
Field :: struct {
    nameLength: u8,
    name: string,
    type: u8,
    valueLength: u32, //keeping this 4bytes
    value: []u8,
}

// Represents a complete record with multiple fields
Record :: struct {
    id: u8,
    fields: [dynamic]Field
}