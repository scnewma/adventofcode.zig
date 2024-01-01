const std = @import("std");

pub fn HashSet(comptime K: type) type {
    return struct {
        m: std.AutoHashMap(K, void),

        const Self = @This();

        pub fn init(allocator: std.mem.Allocator) Self {
            return .{ .m = std.AutoHashMap(K, void).init(allocator) };
        }

        pub fn deinit(self: *Self) void {
            self.m.deinit();
            self.* = undefined;
        }

        // Adds a value to the set.
        // Returns whether the value was newly inserted.
        pub fn insert(self: *Self, key: K) !bool {
            var new = false;
            if (!self.contains(key)) {
                try self.m.put(key, {});
                new = true;
            }
            return new;
        }

        pub fn contains(self: *Self, key: K) bool {
            return self.m.contains(key);
        }

        pub fn count(self: Self) usize {
            return self.m.count();
        }

        pub fn iterator(self: *const Self) std.AutoHashMap(K, void).KeyIterator {
            return self.m.keyIterator();
        }

        pub fn intersectionIterator(self: *const Self, other: HashSet(K)) IntersectionIterator(K) {
            return .{ .iter = self.iterator(), .other = other };
        }
    };
}

pub fn IntersectionIterator(comptime K: type) type {
    return struct {
        iter: std.AutoHashMap(K, void).KeyIterator,
        other: HashSet(K),

        const Self = @This();

        pub fn next(self: *Self) ?K {
            while (self.iter.next()) |e| {
                if (self.other.contains(e.*)) {
                    return e.*;
                }
            }
            return null;
        }
    };
}
