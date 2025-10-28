package serializer


serialize_u64 :: proc(val: u64) -> [8]u8{
    return transmute([8]u8)val
}

serialize_u32 :: proc(val: u32) -> [4]u8{
    return transmute([4]u8)val
}




