const std = @import("std");
const testing = std.testing;

const grids = @import("./grids.zig");
const sets = @import("./sets.zig");

const Point = grids.Point;

const DELTAS = [_][2]isize{
    .{ 0, 1 },
    .{ 0, -1 },
    .{ 1, 0 },
    .{ -1, 0 },
    .{ 1, 1 },
    .{ -1, -1 },
    .{ 1, -1 },
    .{ -1, 1 },
};

pub fn part01(allocator: std.mem.Allocator, input: []const u8) !usize {
    var grid = try grids.fromStr(allocator, input);
    defer grid.deinit();

    const parts = try findParts(allocator, grid);
    defer parts.deinit();

    var sum: usize = 0;
    for (parts.items) |part| {
        var adjsym = false;
        for (part.range[0]..part.range[1] + 1) |col| {
            for (DELTAS) |delta| {
                const nr: isize = @as(isize, @intCast(part.row)) + delta[0];
                const nc: isize = @as(isize, @intCast(col)) + delta[1];

                if (grid.get(nr, nc)) |ch| {
                    adjsym = adjsym or (!std.ascii.isDigit(ch) and ch != '.');
                }
            }
        }
        if (adjsym) {
            sum += part.value;
        }
    }
    return sum;
}

pub fn part02(allocator: std.mem.Allocator, input: []const u8) !usize {
    var grid = try grids.fromStr(allocator, input);
    defer grid.deinit();

    const parts = try findParts(allocator, grid);
    defer parts.deinit();

    var sum: usize = 0;
    for (0..grid.height) |row| {
        for (0..grid.width) |col| {
            if (grid.get(row, col).? != '*') {
                continue;
            }

            var connected_parts = sets.HashSet(PartNo).init(allocator);
            for (DELTAS) |delta| {
                const nr: isize = @as(isize, @intCast(row)) + delta[0];
                const nc: isize = @as(isize, @intCast(col)) + delta[1];

                if (partAt(parts.items, nr, nc)) |part| {
                    _ = try connected_parts.insert(part);
                }
            }
            if (connected_parts.count() == 2) {
                var ratio: usize = 1;
                var it = connected_parts.iterator();
                while (it.next()) |part| {
                    ratio *= part.value;
                }
                sum += ratio;
            }
            connected_parts.deinit();
        }
    }

    return sum;
}

fn findParts(allocator: std.mem.Allocator, grid: grids.Grid) !std.ArrayList(PartNo) {
    var parts = std.ArrayList(PartNo).init(allocator);
    var seen = sets.HashSet(Point).init(allocator);
    defer seen.deinit();
    for (0..grid.height) |row| {
        for (0..grid.width) |col| {
            if (!try seen.insert(Point.new(row, col)) or
                !std.ascii.isDigit(grid.get(row, col).?))
            {
                continue;
            }

            var end = col;
            while (end < grid.width and
                std.ascii.isDigit(grid.get(row, end).?))
            {
                _ = try seen.insert(Point.new(row, end));
                end += 1;
            }

            const range: Range = .{ col, end - 1 };
            var value: usize = 0;
            for (range[0]..range[1] + 1) |c| {
                const d = grid.get(row, c).? - '0';
                value = value * 10 + d;
            }

            try parts.append(.{
                .row = row,
                .range = range,
                .value = value,
            });
        }
    }
    return parts;
}

fn partAt(part_numbers: []PartNo, row: isize, col: isize) ?PartNo {
    for (part_numbers) |partno| {
        if (partno.row == row and col >= partno.range[0] and col <= partno.range[1]) {
            return partno;
        }
    }
    return null;
}

const Range = std.meta.Tuple(&.{ usize, usize });

const PartNo = struct {
    row: usize,
    range: Range,
    value: usize,
};

const INPUT = @embedFile("inputs/day03.txt");

test "part01" {
    try testing.expect(try part01(testing.allocator, INPUT) == 527144);
}

test "part02" {
    try testing.expect(try part02(testing.allocator, INPUT) == 81463996);
}
