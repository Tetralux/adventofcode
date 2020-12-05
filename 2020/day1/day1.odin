package day1

import "core:os"
import "core:strings"
import "core:strconv"
import "core:fmt"

main :: proc() {
    using fmt;

    input, ok := os.read_entire_file("input.lsv");
    assert(ok);

    data := lines_to_data(string(input));

    //
    // Part 1
    //
    outer1: for a in data {
        for b in data {
            if a+b == 2020 {
                println(a, b, "=>", a*b);
                break outer1;
            }
        }
    }


    //
    // Part 2
    //
    outer2: for a in data {
        for b in data {
            for c in data {
                if a+b+c == 2020 {
                    println(a, b, c, "=>", a*b*c);
                    break outer2;
                }
            }
        }
    }
}


lines_to_data :: proc(s: string) -> []int {
    out: [dynamic]int;

    s := s;
    for len(s) > 0 {
        line: string;
        line, s = next_line(s);
        value, ok := strconv.parse_int(line);
        assert(ok);

        append(&out, value);
    }

    return out[:];
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
        case i8, i16, i32, i64, int:
            fmt.sbprintf(&s, "%v", e);
        }

        write_rune(&s, '\n');
    }

    return to_string(s);
}