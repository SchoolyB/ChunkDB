package main
import "core:fmt"
import lib"../src/library"
import S"../src/core/serializer"


main :: proc() {
foo:= S.serialize_u64(256)
bar:= S.serialize_u32(1020)
fmt.println("FOO: ", foo)
fmt.println("BAR: ", bar)
}


