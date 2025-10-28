package codec


deserialize_to_u64 :: proc(val: [8]u8) -> u64{
    return transmute(u64)val
}

deserialize_to_u32 :: proc(val:[4]u8) -> u32 {
    return transmute(u32)val
}

deserialize_to_u16 :: proc (val:[2]u8) -> u16{
    return transmute(u16)val
}

deserialize_to_u8 :: proc(val:[1]u8) -> u8 {
    return transmute(u8)val
}

deserialize_to_f64 :: proc(val:[8]u8) -> f64{
    return transmute(f64)val
}
