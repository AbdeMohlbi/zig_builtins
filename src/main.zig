const std = @import("std");
const Io = std.Io;
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;
const print = std.debug.print;
const mem = @import("std").mem;
const zig_builtins = @import("zig_builtins");

pub fn main() !void {}

test "@addWithOverflow tests" {
    // addition that does not cause an overflow
    const var_1: u8 = 20;
    const var_2: u8 = 30;
    try expectEqual(@addWithOverflow(var_1, var_2), .{ 50, 0 });

    // addition that causes an overflow because max allowed number is 255
    const var_3: u8 = 200;
    const var_4: u8 = 100;
    // the reason to why the result 44 and not 45, is because (max u8) 255 + 1 is 0 with in the overflow bit
    // ie: one addition is wasted on the first overflow 0.
    try expectEqual(@addWithOverflow(var_3, var_4), .{ 44, 1 });

    const var_5: u8 = 200;
    const var_6: u8 = 100;
    try expectEqual(@addWithOverflow(var_5, var_6), .{ 44, 1 });
}

test "@subWithOverflow tests" {
    // subtraction that does not cause an overflow
    const var_1: u8 = 20;
    const var_2: u8 = 3;
    try expectEqual(@subWithOverflow(var_1, var_2), .{ 17, 0 });

    // subtraction that causes an overflow because max allowed number is 255
    const var_3: u8 = 20;
    const var_4: u8 = 20;
    try expectEqual(@subWithOverflow(var_3, var_4), .{ 0, 0 });

    const var_5: u8 = 200;
    const var_6: u8 = 100;
    // counts from 255
    try expectEqual(@subWithOverflow(var_6, var_5), .{ 156, 1 });
}

test "@mulWithOverflow tests" {
    // mul that does not cause an overflow
    const var_1: u8 = 20;
    const var_2: u8 = 3;
    try expectEqual(@mulWithOverflow(var_1, var_2), .{ 60, 0 });

    // mul with that causes an overflow because max allowed number is 255
    const var_3: u8 = 20;
    const var_4: u8 = 20;
    try expectEqual(@mulWithOverflow(var_3, var_4), .{ 144, 1 });
}
