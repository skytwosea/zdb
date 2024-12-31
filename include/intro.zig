const std = @import("std");
const stdout = std.io.getStdOut().writer();

const sdb = @This();

pub fn say_hello() !void {
    try stdout.print("Hello zdb\n", .{});
    return;
}
