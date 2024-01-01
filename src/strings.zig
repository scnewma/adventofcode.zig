const std = @import("std");
const testing = std.testing;

pub fn splitOnce(buffer: []const u8, delimiter: []const u8) ?std.meta.Tuple(&.{ []const u8, []const u8 }) {
    const maybeIdx = std.mem.indexOf(u8, buffer, delimiter);
    if (maybeIdx) |idx| {
        return .{ buffer[0..idx], buffer[idx + delimiter.len ..] };
    } else {
        return null;
    }
}
