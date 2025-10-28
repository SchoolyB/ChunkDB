package codec
import "core:encoding/endian"
import lib"../../library"

// ????
serialize_u16_big_E :: proc(val: u16) -> [2]u8{
    result:[2]u8
    endian.put_u16(result[:], .Big, val)
    return result
}

@(require_results)
serialize_u64 :: proc(val: u64) -> [8]u8{
    return transmute([8]u8)val
}

@(require_results)
serialize_u32 :: proc(val: u32) -> [4]u8{
    return transmute([4]u8)val
}

@(require_results)
serialize_u16 :: proc (val:u16) -> [2]u8{
    return transmute([2]u8)val
}

@(require_results)
serialize_u8 :: proc(val: u8) -> [1]u8 {
    return transmute([1]u8)val
}

@(require_results)
serialize_f64 :: proc(val: f64) -> [8]u8{
    return transmute([8]u8)val
}

@(require_results)
serialize_string:: proc(val: string) -> []u8{
    return transmute([]u8)val
}

//Helper that gets the prefix of a field name and returns the 2 byte representation
// TODO: Move me somewhere else???
@(require_results)
get_field_name_prefix :: proc(val: string) ->[2]u8 {
    result := u16(len(val))
    return serialize_u16(result)
}

//Todo: move me too?
@(require_results)
serialize_field :: proc(f: lib.Field) -> []u8{
    result: [dynamic]u8

    //append the 2 name length bytes prefix
    nameLenBytes := serialize_u16(f.nameLength)
    append(&result, nameLenBytes[0], nameLenBytes[1])

     //and the name bytes representation  itself
     append(&result, ..f.name)

    //add the type byte if its an array make sure to user proper
    typeByte := serialize_u8(f.type)
    append(&result, typeByte[0])

     //add 4 value len bytes
     valLenBytes := serialize_u32(f.valueLength)
     append(&result, valLenBytes[0], valLenBytes[1], valLenBytes[2], valLenBytes[3])

    // Add value bytes representation
    append(&result, ..f.value)

    return result[:]
}
