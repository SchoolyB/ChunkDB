package data

import lib"../../library"


@(require_results)
make_new_record :: proc(name:string) -> ^lib.Record{
    record:= new(lib.Record)

    record.id = 0 //TODO: will need to build proc to get accurate count
    record.fields = make([dynamic]lib.Field)

    return record
}

append_field_to_record :: proc(r: ^lib.Record, f: lib.Field) -> ^lib.Record{
    append(&r.fields, f)

    return r
}

append_fields_to_record :: proc(r: ^lib.Record, fields: [dynamic]lib.Field) -> ^lib.Record{
    for f in fields{
        append_field_to_record(r, f)
    }
    return r
}

