const std = @import("std");
const testing = std.testing;

fn readStdinString(allocator: std.mem.Allocator) ![]const u8 {
    var stdin = std.io.getStdIn();
    const stat = try stdin.stat();
    return try stdin.reader().readAllAlloc(allocator, stat.size);
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    const input = try readStdinString(allocator);

    std.debug.print("Part 01: {}\n", .{try part01(allocator, input)});
    std.debug.print("Part 02: {}\n", .{try part02(allocator, input)});
}

fn part01(allocator: std.mem.Allocator, input: []const u8) !usize {
    var ans: usize = 0;
    var lines = std.ArrayList([]const u8).init(allocator);
    defer lines.deinit();
    var linesIter = std.mem.tokenize(u8, input, "\n");
    while (linesIter.next()) |line| {
        var left: ?usize = null;
        var right: usize = 0;

        for (line) |ch| {
            if (std.ascii.isDigit(ch)) {
                left = left orelse ch - '0';
                right = ch - '0';
            }
        }
        ans += (left.? * 10) + right;
    }
    return ans;
}

const WORDS = [_][]const u8{
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
};

fn part02(allocator: std.mem.Allocator, input: []const u8) !usize {
    var ans: usize = 0;
    var lines = std.ArrayList([]const u8).init(allocator);
    defer lines.deinit();
    var linesIter = std.mem.tokenize(u8, input, "\n");
    while (linesIter.next()) |line| {
        var left: ?usize = null;
        var right: usize = 0;

        for (line, 0..) |ch, i| {
            if (std.ascii.isDigit(ch)) {
                left = left orelse ch - '0';
                right = ch - '0';
            } else {
                for (WORDS, 1..) |word, value| {
                    if (std.mem.startsWith(u8, line[i..], word)) {
                        left = left orelse value;
                        right = value;
                    }
                }
            }
        }
        ans += (left.? * 10) + right;
    }
    return ans;
}

const INPUT = @embedFile("inputs/day01.txt");

test "part01" {
    try testing.expect(try part01(testing.allocator, INPUT) == 54951);
}

test "part02" {
    try testing.expect(try part02(testing.allocator, INPUT) == 55218);
}
