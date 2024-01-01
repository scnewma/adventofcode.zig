const std = @import("std");
const sets = @import("./sets.zig");
const strings = @import("./strings.zig");
const itertools = @import("./itertools.zig");

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

        var intersection = winning.intersectionIterator(mine);
        const count: u32 = @intCast(itertools.count(&intersection));

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

        var intersection = winning.intersectionIterator(mine);
        const count: u32 = @intCast(itertools.count(&intersection));

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

        try games.append(.{ try createSet(allocator, nums.left), try createSet(allocator, nums.right) });
    }

    return games;
}

fn createSet(allocator: std.mem.Allocator, s: []const u8) !sets.HashSet(u32) {
    var set = sets.HashSet(u32).init(allocator);
    var setIter = std.mem.tokenizeScalar(u8, s, ' ');
    while (setIter.next()) |w| {
        const n = try std.fmt.parseInt(u32, w, 10);
        _ = try set.insert(n);
    }
    return set;
}

const INPUT = @embedFile("inputs/day04.txt");

test "part01" {
    try testing.expect(try part01(testing.allocator, INPUT) == 20117);
}

test "part02" {
    try testing.expect(try part02(testing.allocator, INPUT) == 13768818);
}
