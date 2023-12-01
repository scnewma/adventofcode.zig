const std = @import("std");

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

pub fn main() !void {
    var stdin = std.io.getStdIn();
    var bufr = std.io.bufferedReader(stdin.reader());
    var reader = bufr.reader();

    var p1sum: usize = 0;
    var p2sum: usize = 0;
    var buffer: [64]u8 = undefined;
    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var left: ?usize = null;
        var right: usize = 0;

        for (line) |ch| {
            if (std.ascii.isDigit(ch)) {
                left = left orelse ch - '0';
                right = ch - '0';
            }
        }
        p1sum += (left.? * 10) + right;

        // part 2
        left = null;
        right = 0;

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
        p2sum += (left.? * 10) + right;
    }

    std.debug.print("Part 01: {}\n", .{p1sum});
    std.debug.print("Part 02: {}\n", .{p2sum});
}
