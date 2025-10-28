package data

import "core:os"
import lib"../../library"
import "../codec"
import "core:time"
import "core:fmt"



make_new_db_header ::proc () -> lib.DatabaseHeader {
    header:lib.DatabaseHeader

    currentTime:= time.now()
    currentNanoSec:= transmute(u64)currentTime._nsec

    header.magicNumber = codec.serialize_string(lib.MAGIC_NUMBER)
    header.createdAt = codec.serialize_u64(currentNanoSec)
    header.lastModifiedAt = codec.serialize_u64(currentNanoSec)
    //TODO: Once allocation stuff is done continue making header

    return header
}


serialize_header :: proc(header: lib.DatabaseHeader ) -> []u8{
    result: [dynamic]u8

    //Append first 10 bytes
    append(&result, ..header.magicNumber) //[67, 72, 85, 78, 75, 68, 66, 95, 86, 49]


    //append next 8
    for i in header.createdAt{
        append(&result, i)
    }

    // append next 8
    for j in header.lastModifiedAt{
        append(&result, j)
    }

    return result[:]
}

append_db_header :: proc(h: lib.DatabaseHeader, path: string) {
    file, openErr := os.open(path, os.O_APPEND | os.O_WRONLY, 0o666)
    if openErr != os.ERROR_NONE {
        fmt.println("Error opening file:", openErr)
        return
    }
    defer os.close(file)

    serial := serialize_header(h)
    fmt.println("erialized data:", serial)
    fmt.println("Len:", len(serial))

    bytes_written, err := os.write(file, serial)
    if err != nil {
        fmt.println("Write error:", err)
    } else {
        fmt.println("Bytes written:", bytes_written)
    }
}