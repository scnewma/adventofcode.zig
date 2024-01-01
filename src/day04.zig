const std = @import("std");
const sets = @import("./sets.zig");
const strings = @import("./strings.zig");

const testing = std.testing;

pub fn part01(allocator: std.mem.Allocator, input: []const u8) !usize {
    // use an arena so that the arraylist + hashsets are all free'd at once.
    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();

    const games = try parseInput(arena.allocator(), input);

    var ans: u32 = 0;
    for (games.items) |game| {
        const winning = game[0];
        const mine = game[1];

        var count: u32 = 0;
        var iter = winning.intersectionIterator(mine);
        while (iter.next()) |_| {
            count += 1;
        }

        if (count > 0) {
            ans += std.math.pow(u32, 2, count - 1);
        }
    }

    return ans;
}

pub fn part02(allocator: std.mem.Allocator, input: []const u8) !usize {
    // use an arena so that the arraylist + hashsets are all free'd at once.
    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();

    const games = try parseInput(arena.allocator(), input);

    var cardCopies = std.ArrayList(usize).init(arena.allocator());
    for (0..games.items.len) |_| {
        try cardCopies.append(1);
    }

    for (games.items, 0..) |game, i| {
        const winning = game[0];
        const mine = game[1];

        var count: u32 = 0;
        var iter = winning.intersectionIterator(mine);
        while (iter.next()) |_| {
            count += 1;
        }

        for (1..count + 1) |j| {
            cardCopies.items[i + j] += cardCopies.items[i];
        }
    }

    var sum: usize = 0;
    for (cardCopies.items) |c| {
        sum += c;
    }
    return sum;
}

const Game = std.meta.Tuple(&.{ sets.HashSet(u32), sets.HashSet(u32) });
const Games = std.ArrayList(Game);

fn parseInput(allocator: std.mem.Allocator, input: []const u8) !Games {
    var games = Games.init(allocator);

    var linesIter = std.mem.tokenizeScalar(u8, input, '\n');
    while (linesIter.next()) |line| {
        const card = strings.splitOnce(line, ": ").?;
        const nums = strings.splitOnce(card.right, " | ").?;

        var winning = sets.HashSet(u32).init(allocator);
        var winningIter = std.mem.tokenizeScalar(u8, nums.left, ' ');
        while (winningIter.next()) |w| {
            const n = try std.fmt.parseInt(u32, w, 10);
            _ = try winning.insert(n);
        }

        var mine = sets.HashSet(u32).init(allocator);
        var mineIter = std.mem.tokenizeScalar(u8, nums.right, ' ');
        while (mineIter.next()) |w| {
            const n = try std.fmt.parseInt(u32, w, 10);
            _ = try mine.insert(n);
        }

        try games.append(.{ winning, mine });
    }

    return games;
}

const INPUT = @embedFile("inputs/day04.txt");

test "part01" {
    try testing.expect(try part01(testing.allocator, INPUT) == 20117);
}

test "part02" {
    try testing.expect(try part02(testing.allocator, INPUT) == 13768818);
}
