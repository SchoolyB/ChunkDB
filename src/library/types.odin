package library

DatbaseHeader :: struct{
    magicNumber: [10]u8, //versioning like: "CHUNKDB_V1"
    version: u32,
    sizePreAllocated: u32, // Size of all pre-allocated overhead (headers, indexes, etc.)
    totalCapacity: u64,
    usedBytes: u64,
    createdAt: u64,
    lastModifiedAt: u64
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
    name: []u8,
    nameLength: u16,
    type: u8,
    value: []u8,
    valueLength: u32,
}

// Represents a complete record with multiple fields
Record :: struct {
    id: u64,
    fields: [dynamic]Field
}


FIELD_TYPE :: enum {
    NULL = 0,
    CHAR,
    INTEGER,
    FLOAT,
    STRING,
    DATE,
    UUID,
    ARRAY //similar to ostrichdb but arrays are just arrays
}