package day5

import "core:fmt"
import "core:strings"
import "core:os"

main :: proc() {
    using fmt;

    input, ok := os.read_entire_file("input.lsv");
    assert(ok);

    lines := strings.split(string(input), "\n");

    m: map[int]int;
    for id in 0..926 {
        m[id] = id;
    }

    for line in lines {
        seat := parse_seat(line);
        delete_key(&m, seat.id);
    }

    println(m);
}

Seat :: struct {
    row, col, id: int,
}

parse_seat :: proc(s: string) -> Seat {
    s := s;

    row: int;
    {
        low, high := 0, 127;

        i := 0;

        row_loop: for r in s {
            n := ((high - low) / 2) + 1;

            switch r {
            case 'F':
                high -= n;
            case 'B':
                low += n;
            case:
                break row_loop;
            }

            i += 1;
        }
        s = s[i:];

        assert(high == low);
        row = low;
    }


    col: int;
    {
        low, high := 0, 7;

        i := 0;

        col_loop: for r in s {
            n := ((high - low) / 2) + 1;

            switch r {
            case 'L':
                high -= n;
            case 'R':
                low += n;
            case:
                break col_loop;
            }

            i += 1;
        }
        s = s[i:];

        assert(high == low);
        col = low;
    }


    assert(s == "");

    id := row * 8 + col;
    return {
        row = row,
        col = col,
        id = id
    };
}


array_to_string :: proc(a: $T/[]$E, limit := 32) -> string {
    using strings;

    s: Builder;
    init_builder(&s);

    fmt.sbprintf(&s, "%v-element []%v:\n", len(a), typeid_of(E));

    for e, i in a {
        if i > limit {
            fmt.sbprintf(&s, "\n <... and %v more>", len(a) - i + 1);
            break;
        }

        write_string(&s, " ");

        switch typeid_of(E) {
        case u8, u16, u32, u64, uint:
            fmt.sbprintf(&s, "%x", e);
        case string:
            fmt.sbprintf(&s, "%q", e);
        case:
            fmt.sbprintf(&s, "%v", e);
        }

        write_rune(&s, '\n');
    }

    return to_string(s);
}