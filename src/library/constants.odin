package library

//DB header shit
MAGIK_NUMBER :[10]byte: "CHUNKDB_V1"
VERSION :[4]byte: 1
DEFAULT_DB_CAPACITY :u64: 512_000 //500kb this includes pre-allocated chunks
MAX_DB_CAPACITY :u64: 5_242_880 //5mb. User cannot allocate anymore




