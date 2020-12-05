package day2

import "core:strings"
import "core:strconv"
import "core:os"
import "core:fmt"

main :: proc() {
    using fmt;

    input, ok := os.read_entire_file("input.lsv");
    assert(ok);

    data := lines_to_data(string(input));

    num_valid := 0;

    for d in data {
        if validate_entry(d) {
            num_valid += 1;
        }
    }

    println(num_valid);
}

Entry :: struct {
    min, max: int,
    target_letter: rune,
    password: string,
}

lines_to_data :: proc(s: string) -> []Entry {
    out: [dynamic]Entry;

    s := s;
    for len(s) > 0 {
        line: string;
        line, s = next_line(s);

        entry := parse_line(line);

        append(&out, entry);
    }

    return out[:];
}

validate_entry :: proc(d: Entry) -> bool {
    count: int;

    for r in d.password {
        if r == d.target_letter {
            count += 1;
        }
    }

    return count >= d.min && count <= d.max;
}

parse_line :: proc(line: string) -> (result: Entry) {
    parts := strings.split(line, " ");
    defer delete(parts);

    assert(len(parts) == 3);

    minmax_string := parts[0];
    target_letter := parts[1];

    result.password = parts[2];


    {
        numbers := strings.split(minmax_string, "-");
        assert(len(numbers) == 2);

        ok: bool;

        result.min, ok = strconv.parse_int(numbers[0]);
        assert(ok);
        result.max, ok = strconv.parse_int(numbers[1]);
        assert(ok);
    }

    {
        assert(len(target_letter) == 2);
        result.target_letter = rune(target_letter[0]);
    }

    return;
}

next_line :: proc(s: string) -> (line, rest: string) {
    i := strings.index_rune(s, '\n');
    if i == -1 {
        return s, "";
    }

    line = s[:i];
    if i < len(s) {
        rest = s[i+1:];
    }

    return;
}


//
// General utils
//

array_to_string :: proc(a: $T/[]$E, limit := 32) -> string {
    using strings;

    s: Builder;
    init_builder(&s);

    fmt.sbprintf(&s, "%v-element []%v:\n", len(a), typeid_of(E));

    for e, i in a {
        if i > limit {
            break;
        }

        write_string(&s, " ");

        switch typeid_of(E) {
        case u8, u16, u32, u64, uint:
            fmt.sbprintf(&s, "%x", e);
        case:
            fmt.sbprintf(&s, "%v", e);
        }

        write_rune(&s, '\n');
    }

    return to_string(s);
}