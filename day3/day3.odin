package day3

import "core:strings"
import "core:os"
import "core:fmt"

main :: proc() {
    using fmt;

    input, ok := os.read_entire_file("input.lsv");
    assert(ok);

    lines := strings.split(string(input), "\n");
    assert(len(lines) > 0);

    {
        // NOTE: we assume all lines are the same length
        length := len(lines[0]);
        for line in lines[1:] {
            assert(len(line) == length);
        }
    }


    Pos :: struct {
        across, down: int,
    };

    move :: proc(chart: []string, pos: ^Pos, across, down: int) {
        pos.across = (pos.across + across) % len(chart[0]); // NOTE: "the pattern repeats..."
        pos.down += down;
    }

    get_at :: proc(chart: []string, pos: Pos) -> byte {
        return chart[pos.down][pos.across];
    }

    in_table :: proc(chart: []string, pos: Pos) -> bool {
        return pos.down < len(chart);
    }



    pos := Pos{0, 0};
    trees_encountered := 0;

    for {
        move(lines, &pos, 3, 1);
        if !in_table(lines, pos) {
            break;
        }

        tile := get_at(lines, pos);
        if tile == '#' {
            trees_encountered += 1;
        }
    }

    println(trees_encountered);
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