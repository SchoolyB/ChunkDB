package library

//DB header shit
MAGIC_NUMBER :string: "CHUNKDB_V1"
VERSION :[4]u8: 1
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
