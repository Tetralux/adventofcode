package day6

import "core:os"
import "core:strings"
import "core:fmt"

main :: proc() {
    using fmt;

    input, ok := os.read_entire_file("input.lsv");
    assert(ok);

    BLANK_LINE :: "\n\n";
    group_data := strings.split(string(input), BLANK_LINE);

    sum := 0;

    for g in group_data {
        people := strings.split(g, "\n", context.temp_allocator);

        m := make(map[rune]bool, 26, context.temp_allocator);

        for person in people {
            for question in person {
                m[question] = true;
            }
        }

        sum += len(m);
    }

    println(sum);
}