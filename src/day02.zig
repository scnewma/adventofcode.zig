const std = @import("std");
const testing = std.testing;
const strings = @import("./strings.zig");

pub fn part01(allocator: std.mem.Allocator, input: []const u8) !usize {
    const MAX_RED: u32 = 12;
    const MAX_GREEN: u32 = 13;
    const MAX_BLUE: u32 = 14;

    var linesIter = std.mem.tokenizeScalar(u8, input, '\n');
    var ans: usize = 0;
    var game_id: usize = 0;
    while (linesIter.next()) |line| {
        game_id += 1;

        const hands = try parse_game(allocator, line);
        var all_possible = true;
        for (hands.items) |hand| {
            if (hand.r > MAX_RED or hand.g > MAX_GREEN or hand.b > MAX_BLUE) {
                all_possible = false;
                break;
            }
        }
        if (all_possible) {
            ans += game_id;
        }
        hands.deinit();
    }
    return ans;
}

pub fn part02(allocator: std.mem.Allocator, input: []const u8) !usize {
    var linesIter = std.mem.tokenizeScalar(u8, input, '\n');
    var ans: usize = 0;
    while (linesIter.next()) |line| {
        const hands = try parse_game(allocator, line);
        var min_hand = RGB.default();
        for (hands.items) |hand| {
            min_hand.r = @max(min_hand.r, hand.r);
            min_hand.g = @max(min_hand.g, hand.g);
            min_hand.b = @max(min_hand.b, hand.b);
        }
        ans += min_hand.r * min_hand.g * min_hand.b;
        hands.deinit();
    }
    return ans;
}

const RGB = struct {
    r: u32,
    g: u32,
    b: u32,

    fn default() RGB {
        return RGB{ .r = 0, .g = 0, .b = 0 };
    }
};

const Color = enum { red, green, blue };

fn parse_game(allocator: std.mem.Allocator, line: []const u8) !std.ArrayList(RGB) {
    var hands = std.ArrayList(RGB).init(allocator);
    const line_data = strings.splitOnce(line, ": ").?;
    var handsIter = std.mem.tokenizeSequence(u8, line_data.right, "; ");
    while (handsIter.next()) |hand| {
        var cubesIter = std.mem.tokenizeSequence(u8, hand, ", ");
        while (cubesIter.next()) |cube| {
            var dataIter = std.mem.tokenizeSequence(u8, cube, " ");
            const count = try std.fmt.parseInt(u32, dataIter.next().?, 10);
            const color_str = dataIter.next().?;
            var rgb = RGB.default();
            if (std.mem.eql(u8, color_str, "red")) {
                rgb.r = count;
            } else if (std.mem.eql(u8, color_str, "green")) {
                rgb.g = count;
            } else if (std.mem.eql(u8, color_str, "blue")) {
                rgb.b = count;
            } else {
                unreachable;
            }

            try hands.append(rgb);
        }
    }
    return hands;
}

const INPUT = @embedFile("inputs/day02.txt");

test "part01" {
    try testing.expect(try part01(testing.allocator, INPUT) == 2720);
}

test "part02" {
    try testing.expect(try part02(testing.allocator, INPUT) == 71535);
}
