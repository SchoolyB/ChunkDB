# ChunkDB - Architecture Design

Ideal Record field storage format:
```
[nameLength prefix = 2 bytes][name = n bytes ][type = 1 byte][valueLength 4 bytes][value = n bytes]
```
---

## Core Philosophy

**Simplicity First**
- Clear, understandable architecture
- Avoid unnecessary complexity
- User control over resources
- Fast by design, not as an afterthought

**Key Principles:**
1. **Pre-allocated storage** - Users specify capacity upfront
2. **Binary format** - Compact, fast parsing from day 1
3. **Chunk-based organization** - Fixed-size regions within files
4. **Built-in indexing** - Performance without complexity
5. **Manual memory management** - Predictable performance

---

## Language Considerations

**Options:** C, Odin, or C++

**Decision Criteria:**
- Memory control (critical for performance)
- Development speed vs runtime performance
- Debugging tools and ecosystem
- Team familiarity

**Current lean:** Odin or C for simplicity and control

---

## Data Model

**Hierarchy:**
```
Database Engine
  └── Region (namespace/tenant) -  a region can have a server running to connect ot multiple DBs??
      └── Database (single database file) possibely give it a `.chunky` of `.chunkdb` extension??
          └── Group (logical grouping of records)
              └── Record (name-type-value triples)
```

**Record Structure:** Simple name-type-value triples, stored in binary format
- Record types:

  TYPE_NULL = 0,
  TYPE_BOOLEAN = 1,
  TYPE_INTEGER = 2,
  TYPE_FLOAT = 3,
  TYPE_STRING = 4,
  TYPE_BYTES = 5,
  TYPE_DATE = 6,
  TYPE_UUID = 7,
  TYPE_ARRAY = 8,


---

## Storage Architecture: Pre-Allocated Chunks

### Core Concept

When it comes time to interact with ChunkDB API, Users should be able to specify what size they would need for a DB.
If no size specified, default to maybe 10mb???
- File is immediately pre-allocated with full size
- Data grows into pre-allocated space
- Optional auto-expansion when nearing capacity

### File Structure

```
Database File (e.g., users.chunky - 100MB pre-allocated)

┌─────────────────────────────────────┐
│ File Header                         │
│  - Magic number, version            │
│  - Capacity, used space             │
│  - Chunk size (default 8KB)         │
│  - Growth settings                  │
└─────────────────────────────────────┘
│ Chunk Directory                     │
│  - Maps cluster names → chunks      │
└─────────────────────────────────────┘
│ Chunk Allocation Bitmap             │
│  - Tracks free/used chunks          │
└─────────────────────────────────────┘
│ Data Chunks (fixed 8KB each)        │
│  - Chunk header (metadata)          │
│  - Record data or index data        │
└─────────────────────────────────────┘
│ Unused Pre-allocated Space          │
│  - Ready for growth                 │
└─────────────────────────────────────┘
```
Index file: Used for fast indexing
Index.chunkDB
*Stores record name bytecode offset values*
├─ "user_name" → offset=36
├─ "user_age"  → offset=53
├─ "email"     → offset=72
└─ "status"    → offset=95

**Chunk Types:** FREE, DATA, INDEX, OVERFLOW (for large records)

---

## Capacity Management

### Growth Strategies

**Auto-expand:** Automatically grow when reaching threshold (e.g., 90% full)
- Uses growth factor (e.g., 1.5x = 50% increase)
- Optional max capacity limit

**Manual expansion:** User explicitly requests more space

**Hybrid (recommended):** Auto-expand up to max limit, then require manual intervention

### Handling Full Collections

- Return clear error when at capacity
- User options: expand limit, archive old data, or shard to new collection

### Compaction

Optional operation to reclaim unused space:
- Rewrites file to remove free chunks
- Releases space back to OS

---

## Indexing Strategy

### Primary Index: Cluster Directory

Built into file header, maps cluster names to chunk locations
- Fast O(log n) lookups via binary search or hash table

### Secondary Indexes (Optional, User-Created)

Users can create indexes on specific fields:
- **Hash indexes:** Fast equality lookups (O(1) average)
- **B-tree indexes:** Range queries and ordering (O(log n))
- Index data stored in dedicated INDEX chunks

**Philosophy:** Small clusters can use sequential scans, indexes only when needed

---

## Binary Encoding

### Record Format

```
Record:
  ├─ Header (fixed size)
  │   ├─ record_id, timestamps, lengths
  │   ├─ type indicator
  │   └─ checksum for integrity
  ├─ Name (variable, UTF-8)
  └─ Value (variable, type-specific binary)
```

**Supported Types:** NULL, BOOLEAN, INTEGER (int64), FLOAT (double), STRING (UTF-8), BYTES, DATE (timestamp), UUID, ARRAY

**Benefits:**
- Compact storage (no text overhead)
- Fast parsing (no string splitting)
- Type safety built-in
- Easy to index fixed-size types

---

## Memory Management Strategy

### Manual Control (No GC)

**Core Principles:**
- Explicit ownership and lifecycle management
- Arena allocators for request-scoped data
- Object pools for frequently allocated types
- Predictable, deterministic performance

### Key Techniques

**Arena Allocators:** Allocate large chunk, bump pointer allocation, free all at once
- Use for: HTTP requests, query processing, transactions
- O(1) cleanup by freeing entire arena

**Object Pools:** Pre-allocate and reuse common objects
- Use for: Records, chunk buffers, index nodes
- Eliminates allocation/deallocation overhead

**Clear Ownership:** Explicit patterns for who allocates and who frees

---

## Concurrency Model

### Phased Approach

**Phase 1: Single-threaded (MVP)**
- One connection at a time, no locks
- Simple, fast to implement and debug

**Phase 2: Reader-writer locks**
- Multiple readers OR one writer per collection
- Collection-level locking

**Phase 3: MVCC (if needed)**
- Multi-version concurrency control
- Readers never block writers
- Only add if proven necessary

**Philosophy:** Start simple, add complexity only when needed

---

## API & Interface

### Dual Mode

**Embedded Library Mode:** Link directly into applications (like SQLite)
- No network overhead
- Direct C API

**Server Mode (optional):** HTTP/REST API for remote access
- Standard REST endpoints for collections, clusters, records, indexes
- Authentication and rate limiting

**Core Operations:**
- Collections: create, open, close, expand, compact
- Clusters: create, list, delete
- Records: insert, read, update, delete, query
- Indexes: create, drop, list

### Query Interface

Programmatic query builder (no SQL parsing):
- WHERE clauses (equals, greater/less than, contains, starts with)
- ORDER BY with ASC/DESC
- LIMIT and OFFSET
- Simple and predictable

---

## Performance Targets

**Operation Latency:**
- Single record lookup: < 100μs (indexed)
- Scan 10K records: < 10ms
- Insert record: < 50μs
- Update record: < 100μs

**Throughput (single-threaded):**
- Reads: 100,000+ ops/sec
- Writes: 50,000+ ops/sec

**Resource Usage:**
- Memory: < 100MB for engine + cache
- Startup time: < 10ms
- File overhead: < 5% (metadata/indexes)

**Concurrency (Phase 2+):**
- 1000+ concurrent readers
- 100+ concurrent writers (across collections)

---

## Implementation Phases

### Phase 0: Prototype (1-2 weeks)
Validate core concepts: file pre-allocation, binary encoding, basic chunk operations

### Phase 1: Core Engine (1-2 months)
Complete chunk management, CRUD operations, memory management, testing

### Phase 2: Querying (2-3 weeks)
Query builder, sequential scan, secondary indexes (hash + b-tree), benchmarks

### Phase 3: Durability & Reliability (2-3 weeks)
Write-ahead log (WAL), crash recovery, checksums, backup/restore

### Phase 4: Network Layer (2-3 weeks)
HTTP REST API, authentication, rate limiting, documentation

### Phase 5: Concurrency (1 month)
Reader-writer locks, connection pooling, transaction support

### Phase 6: Production Ready (1 month)
Comprehensive testing, performance tuning, documentation, CLI tools

**Estimated Timeline: 4-5 months for production-ready v1**

---

## Open Questions

1. **Language choice**: Final decision on C vs Odin vs C++?
2. **Default chunk size**: 8KB? 16KB? Configurable?
3. **Index implementation**: Build from scratch or use library?
4. **Compression**: Support per-chunk compression?
5. **Encryption**: Built-in or delegate to filesystem?
6. **Replication**: Future concern or design for it now?

---

## Next Steps

1. Finalize language choice
2. Build Phase 0 prototype to validate core concepts
3. Benchmark pre-allocation performance
4. Test chunk size options (4KB, 8KB, 16KB, 32KB)
5. Create GitHub repository
6. Iterate on design as we learn

---

## Binary Format Example

### Example: users.db Collection

This shows what a small ChunkDB file looks like - plain text concepts on the left, actual binary storage on the right:

**Plain Text (Conceptual)**                    | **Binary Format (Actual Storage)**
--------------------------------------------- | --------------------------------------------------
**FILE HEADER**                               | **FILE HEADER**
Magic: "CHUNKDB1"                            | `43 48 55 4E 4B 44 42 31` (8 bytes)
Version: 1                                    | `00 00 00 01` (4 bytes)
Total capacity: 1048576 (1MB)                | `00 00 00 00 00 10 00 00` (8 bytes)
Used bytes: 156                              | `00 00 00 00 00 00 00 9C` (8 bytes)
Chunk size: 8192                             | `00 00 20 00` (4 bytes)
... (more metadata) ...                       | ... (timestamps, flags, etc.) ...
                                             |
**CHUNK DIRECTORY**                          | **CHUNK DIRECTORY**
Cluster "active" → chunk 5                   | `06 61 63 74 69 76 65 00 00 00 05` (name_len + "active" + chunk_id)
                                             |
**CHUNK 5 - DATA**                           | **CHUNK 5 - DATA**
Chunk Header:                                | Chunk Header:
  chunk_id: 5                                | `00 00 00 05` (4 bytes)
  type: DATA (1)                             | `01` (1 byte)
  used: 156 bytes                            | `00 9C` (2 bytes)
                                             |
**RECORD 1:**                                | **RECORD 1:**
record_id: 1001                              | `00 00 00 00 00 00 03 E9` (8 bytes)
                                             |
Field: "name"                                | Field: "name"
  name_length: 4                             | `00 04` (2 bytes)
  type: STRING (4)                           | `04` (1 byte)
  value_length: 5                            | `00 00 00 05` (4 bytes)
  value: "Alice"                             | `41 6C 69 63 65` (5 bytes UTF-8)
                                             |
Field: "age"                                 | Field: "age"
  name_length: 3                             | `00 03` (2 bytes)
  type: INTEGER (2)                          | `02` (1 byte)
  value_length: 8                            | `00 00 00 08` (4 bytes)
  value: 30                                  | `00 00 00 00 00 00 00 1E` (8 bytes int64)
                                             |
Field: "active"                              | Field: "active"
  name_length: 6                             | `00 06` (2 bytes)
  type: BOOLEAN (1)                          | `01` (1 byte)
  value_length: 1                            | `00 00 00 01` (4 bytes)
  value: true                                | `01` (1 byte)
                                             |
**RECORD 2:**                                | **RECORD 2:**
record_id: 1002                              | `00 00 00 00 00 00 03 EA` (8 bytes)
                                             |
Field: "name"                                | Field: "name"
  name_length: 4                             | `00 04` (2 bytes)
  type: STRING (4)                           | `04` (1 byte)
  value_length: 3                            | `00 00 00 03` (4 bytes)
  value: "Bob"                               | `42 6F 62` (3 bytes UTF-8)
                                             |
Field: "scores"                              | Field: "scores"
  name_length: 6                             | `00 06` (2 bytes)
  type: ARRAY (8)                            | `08` (1 byte)
  element_type: INTEGER (2)                  | `02` (1 byte) ← Array element type!
  element_count: 3                           | `00 00 00 03` (4 bytes)
  values: [10, 20, 30]                       | `00 00 00 00 00 00 00 0A` (int64: 10)
                                             | `00 00 00 00 00 00 00 14` (int64: 20)
                                             | `00 00 00 00 00 00 00 1E` (int64: 30)

### Key Observations:

1. **No colons, no text separators** - Everything is length-prefixed or fixed-size
2. **Type codes are 1 byte** - `02` = INTEGER, `04` = STRING, `08` = ARRAY
3. **Arrays include element type** - `08 02` means "array of integers"
4. **Field names stored as bytes** - "age" = `61 67 65` (3 bytes)
5. **Much faster to parse** - No string splitting, direct memory reads

**File size comparison for these 2 records:**
- Text format (like OstrichDB): ~120 bytes
- Binary format (ChunkDB): ~150 bytes (more overhead, but 10-100x faster access)

The binary format trades a bit of space for massive speed improvements!

---

**ChunkDB: Simple, fast, and maintainable database architecture.**
