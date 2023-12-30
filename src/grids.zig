const std = @import("std");

pub const Point = struct {
    x: isize,
    y: isize,

    const Self = @This();

    pub fn new(row: anytype, col: anytype) Self {
        return Point{ .x = @intCast(col), .y = @intCast(row) };
    }
};

pub const Grid = struct {
    points: std.AutoHashMap(Point, u8),
    width: usize,
    height: usize,

    const Self = @This();

    pub fn get(self: Self, row: anytype, col: anytype) ?u8 {
        return self.points.get(Point{ .x = @intCast(col), .y = @intCast(row) });
    }

    pub fn deinit(self: *Self) void {
        self.points.deinit();
        self.* = undefined;
    }
};

pub fn fromStr(allocator: std.mem.Allocator, s: []const u8) !Grid {
    var grid = Grid{
        .points = std.AutoHashMap(Point, u8).init(allocator),
        .width = 0,
        .height = 0,
    };

    var linesIter = std.mem.tokenizeScalar(u8, s, '\n');
    var row: usize = 0;
    while (linesIter.next()) |line| {
        for (line, 0..) |ch, col| {
            try grid.points.putNoClobber(Point{ .x = @intCast(col), .y = @intCast(row) }, ch);
            grid.width = col + 1;
        }
        row += 1;
        grid.height = row;
    }

    return grid;
}

pub fn print(grid: Grid) !void {
    for (0..grid.height) |row| {
        for (0..grid.width) |col| {
            std.debug.print("{c}", .{grid.get(row, col).?});
        }
        std.debug.print("\n", .{});
    }
}
