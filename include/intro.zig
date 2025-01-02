const std = @import("std");
const stdout = std.io.getStdOut().writer();
const testing = std.testing;

const sdb = @This();

pub fn say_hello() !void {
    try stdout.print("Hello zdb!\n", .{});
    return;
}

test "confirm testing" {
    try testing.expect(true);
}
