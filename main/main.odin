package main
import "core:fmt"
import lib"../src/library"
import "../src/core/codec"


main :: proc() {
    foo:= codec.serialize_u64(256)
    goob:= codec.deserialize_to_u64(foo)

    // bar:= codec.serialize_u32(1020)
    // baz:= codec.serialize_f64(420.69)

    fmt.println("FOO: ", foo)
    // fmt.println("BAR: ", bar)
    // fmt.println("BAZ: ", baz)
    fmt.println("GOOB: ", goob)
}


