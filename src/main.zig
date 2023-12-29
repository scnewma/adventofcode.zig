const std = @import("std");
const lib = @import("aoclib");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    if (args.len != 2) {
        return error.InvalidInput;
    }

    const day = try std.fmt.parseInt(usize, args[1], 10);

    const input = try readStdinString(allocator);
    const solution = try lib.executeDay(allocator, input, day);
    std.debug.print("--- Day {} ---\n", .{day});
    std.debug.print("  Part 1: {s}\n", .{solution.part01});
    std.debug.print("  Part 2: {s}\n", .{solution.part02});
}

fn readStdinString(allocator: std.mem.Allocator) ![]const u8 {
    var stdin = std.io.getStdIn();
    const stat = try stdin.stat();
    return try stdin.reader().readAllAlloc(allocator, stat.size);
}
