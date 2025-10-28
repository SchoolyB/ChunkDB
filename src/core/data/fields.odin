package data
import lib"../../library"



make_new_field :: proc(name: string, type: u8, value: []u8) -> lib.Field {
    return lib.Field{
        name = transmute([]u8)name,
        nameLength = u16(len(name)),
        type = type,
        value = value,
        valueLength = u32(len(value)),
    }
}