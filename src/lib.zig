const std = @import("std");

const Solution = struct {
    part01: []const u8,
    part02: []const u8,
};

const DAYS = [_]*const fn (std.mem.Allocator, []const u8) anyerror!Solution{
    &dayExecutor(1),
    &dayExecutor(2),
    &dayExecutor(3),
    &dayExecutor(4),
};

fn dayExecutor(comptime no: comptime_int) fn (std.mem.Allocator, []const u8) anyerror!Solution {
    const import = switch (no) {
        1 => blk: {
            break :blk @import("./day01.zig");
        },
        2 => blk: {
            break :blk @import("./day02.zig");
        },
        3 => blk: {
            break :blk @import("./day03.zig");
        },
        4 => blk: {
            break :blk @import("./day04.zig");
        },
        else => @compileError("day not yet configured"),
    };

    const solver = struct {
        fn solve(allocator: std.mem.Allocator, input: []const u8) !Solution {
            const part01 = try import.part01(allocator, input);
            const part02 = try import.part02(allocator, input);
            return .{
                .part01 = try std.fmt.allocPrint(allocator, "{d}", .{part01}),
                .part02 = try std.fmt.allocPrint(allocator, "{d}", .{part02}),
            };
        }
    };

    return solver.solve;
}

pub fn executeDay(allocator: std.mem.Allocator, input: []const u8, no: usize) !Solution {
    if (no < 1 or no > 25) {
        return error.InvalidDay;
    }
    if (no > DAYS.len) {
        return error.NotYetSolved;
    }
    return DAYS[no - 1](allocator, input);
}

test {
    inline for (DAYS) |day| {
        _ = day.import;
    }
}
