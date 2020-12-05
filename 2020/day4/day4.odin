package day4

import "core:strings"
import "core:strconv"
import "core:os"
import "core:fmt"

main :: proc() {
    using fmt;

    input, ok := os.read_entire_file("input.lsv");
    assert(ok);

    passports := lines_to_data(string(input));

    num_valid: int;

    for pp in passports {
        if validate_passport(pp) {
            num_valid += 1;
        }

    }

    println(num_valid);
}

validate_passport :: proc(pp: Passport) -> bool {
    {
        if len(pp.byr) != 4 { return false; }

        val, ok := strconv.parse_int(pp.byr, 10);
        if !ok { return false; }

        switch val {
        case 1920..2002: // okay
        case:            return false;
        }
    }

    {
        if len(pp.iyr) != 4 { return false; }

        val, ok := strconv.parse_int(pp.iyr, 10);
        if !ok { return false; }

        switch val {
        case 2010..2020: // okay
        case:            return false;
        }
    }

    {
        if len(pp.eyr) != 4 { return false; }

        val, ok := strconv.parse_int(pp.eyr, 10);
        if !ok { return false; }

        switch val {
        case 2020..2030: // okay
        case:            return false;
        }
    }

    {
        i := 0;
        loop: for ; i < len(pp.hgt); i += 1 {
            switch pp.hgt[i] {
            case '0'..'9':
                // okay
            case:
                break loop;
            }
        }

        val, ok := strconv.parse_int(pp.hgt[:i], 10);
        if !ok { return false; }

        units := pp.hgt[i:];
        switch units {
        case "cm":
            switch val {
            case 150..193: // okay
            case:          return false;
            }
        case "in":
            switch val {
            case 59..76: // okay
            case:        return false;
            }
        case:
            return false;
        }
    }

    if len(pp.hcl) == 0 { return false; }
    if pp.hcl[0] != '#' { return false; }
    {
        n := 0;
        loop2: for r in pp.hcl[1:] {
            switch r {
            case '0'..'9', 'a'..'f': n += 1;
            case:                    break loop2;
            }
        }
        if n != 6 { return false; }

        val, ok := strconv.parse_int(pp.hcl[1:], 16);
        if !ok { return false; }
    }

    switch pp.ecl {
    case "amb", "blu", "brn", "gry", "grn", "hzl", "oth":
        // okay
    case:
        return false;
    }

    if len(pp.pid) != 9 { return false; }

    // NOTE: ignore cid

    return true;
}

Passport :: struct {
    byr: string, // Birth Year
    iyr: string, // Issue Year
    eyr: string, // Expiration Year
    hgt: string, // Height
    hcl: string, // Hair Color
    ecl: string, // Eye Color
    pid: string, // Passport ID
    cid: string, // Country ID
}

lines_to_data :: proc(s: string) -> []Passport {
    out: [dynamic]Passport;

    BLANK_LINE :: "\n\n";
    blocks := strings.split(s, BLANK_LINE);
    defer delete(blocks);

    for block in blocks {
        pairs := strings.split_multi(block, []string{" ", "\n"}, true, context.temp_allocator);

        passport: Passport;

        for pair in pairs {
            parts := strings.split(pair, ":", context.temp_allocator);
            assert(len(parts) == 2);

            key, value := parts[0], parts[1];

            switch key {
            case "byr":  passport.byr = value;
            case "iyr":  passport.iyr = value;
            case "eyr":  passport.eyr = value;
            case "hgt":  passport.hgt = value;
            case "hcl":  passport.hcl = value;
            case "ecl":  passport.ecl = value;
            case "pid":  passport.pid = value;
            case "cid":  passport.cid = value;

            case:
                fmt.panicf("invalid key %q", key);
            }
        }

        append(&out, passport);
    }

    return out[:];
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