const std = @import("std");
const testing = std.testing;

pub fn part01(_: std.mem.Allocator, input: []const u8) !usize {
    var ans: usize = 0;
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

pub fn part02(_: std.mem.Allocator, input: []const u8) !usize {
    var ans: usize = 0;
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
