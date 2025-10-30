package library

import "core:os"
import "core:fmt"


make_db_file :: proc(path: string) -> bool {
    file, openErr := os.open(path, os.O_CREATE | os.O_RDWR, 0o777)
    if openErr != os.ERROR_NONE {
        fmt.println("Error creating file:", openErr)
        return false
    }
    defer os.close(file)

    fmt.println("File created successfully")
    return true
}
