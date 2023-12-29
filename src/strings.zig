const std = @import("std");
const testing = std.testing;

pub fn splitOnce(buffer: []const u8, delimiter: []const u8) ?struct { left: []const u8, right: []const u8 } {
    const maybeIdx = std.mem.indexOf(u8, buffer, delimiter);
    if (maybeIdx) |idx| {
        return .{ .left = buffer[0..idx], .right = buffer[idx + delimiter.len ..] };
    } else {
        return null;
    }
}
