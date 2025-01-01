const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const intro_module = b.addModule("intro", .{
        .root_source_file = b.path("intro.zig"),
        .target = target,
        .optimize = optimize,
    });
    const libzdb_module = b.addModule("libzdb", .{
        .root_source_file = b.path("libzdb.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "intro", .module = intro_module },
        }
    });
    _ = libzdb_module;
}
