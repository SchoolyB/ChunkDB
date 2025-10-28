package codec


serialize_u64 :: proc(val: u64) -> [8]u8{
    return transmute([8]u8)val
}

serialize_u32 :: proc(val: u32) -> [4]u8{
    return transmute([4]u8)val
}

serialize_u16 :: proc (val:u16) -> [2]u8{
    return transmute([2]u8)val
}

serialize_u8 :: proc(val: u8) -> [1]u8 {
    return transmute([1]u8)val
}

serialize_f64 :: proc(val: f64) -> [8]u8{
    return transmute([8]u8)val
}
