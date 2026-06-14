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

test "@as tests" {
    // Performs Type Coercion. This cast is allowed when the conversion is unambiguous and safe,
    // and is the preferred way to convert between types, whenever possible.
    const var_1 = 255;
    // the value of the second operand should be a subtype of the type given in the first operand
    try expectEqual(@as(u32, var_1), 255);

    const var_2 = @as(u16, var_1);
    try expectEqual(var_2, 255);

    const var_3 = @as(u8, var_2);
    try expectEqual(var_3, 255);
}

test "@select tests" {
    // Selects values element-wise from a or b based on pred. If pred[i] is true,
    // the corresponding element in the result will be a[i] and otherwise b[i].
    const Vec8i32 = @Vector(8, i32);

    const a: Vec8i32 = .{ 10, 20, 30, 40, 50, 60, 70, 80 };
    const b: Vec8i32 = .{ 1, 2, 3, 4, 5, 6, 7, 8 };

    const mask: @Vector(8, bool) = .{ true, false, true, false, true, false, true, false };

    const result = @select(i32, mask, a, b);
    try expectEqual(result, .{ 10, 2, 30, 4, 50, 6, 70, 8 });
}

test "@sizeOf tests" {
    inline for (.{ i1, i2, i3, i4, i5, i6, i7, i8 }) |Type| {
        try expectEqual(@sizeOf(Type), 1);
    }

    inline for (.{ i9, i10, i11, i12, i13, i14, i15, i16 }) |Type| {
        try expectEqual(@sizeOf(Type), 2);
    }
    inline for (.{ u1, u2, u3, u4, u5, u6, u7, u8 }) |Type| {
        try expectEqual(@sizeOf(Type), 1);
    }

    inline for (.{ u9, u10, u11, u12, u13, u14, u15, u16 }) |Type| {
        try expectEqual(@sizeOf(Type), 2);
    }

    inline for (.{ i17, u17 }) |Type| {
        try expectEqual(@sizeOf(Type), 4);
    }
    inline for (.{ i33, u33 }) |Type| {
        try expectEqual(@sizeOf(Type), 8);
    }
}
