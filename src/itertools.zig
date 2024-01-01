const std = @import("std");

pub fn count(it: anytype) usize {
    var cnt: usize = 0;
    while (it.next()) |_| {
        cnt += 1;
    }
    return cnt;
}
