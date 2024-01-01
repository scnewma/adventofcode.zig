const std = @import("std");

const Solution = struct {
    part01: []const u8,
    part02: []const u8,
};

const Day = struct {
    no: usize,
    import: type,
};

const DAYS = [_]Day{
    .{ .no = 1, .import = @import("./day01.zig") },
    .{ .no = 2, .import = @import("./day02.zig") },
    .{ .no = 3, .import = @import("./day03.zig") },
    .{ .no = 4, .import = @import("./day04.zig") },
};

pub fn executeDay(allocator: std.mem.Allocator, input: []const u8, no: usize) !Solution {
    // this has to be an inline for instead of an array lookup because the
    // types differ at compile time.
    inline for (DAYS) |day| {
        if (day.no == no) {
            const part01 = try day.import.part01(allocator, input);
            const part02 = try day.import.part02(allocator, input);
            return .{
                .part01 = try std.fmt.allocPrint(allocator, "{d}", .{part01}),
                .part02 = try std.fmt.allocPrint(allocator, "{d}", .{part02}),
            };
        }
    }

    return error.NotYetSolved;
}

test {
    inline for (DAYS) |day| {
        _ = day.import;
    }
}
