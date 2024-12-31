const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    const intro_module = b.addModule("intro", .{
        .root_source_file = b.path("intro.zig"),
    });
    const libzdb_module = b.addModule("libzdb", .{
        .root_source_file = b.path("libzdb.zig"),
        .imports = &.{
            .{ .name = "intro", .module = intro_module },
        }
    });
    _ = libzdb_module;
}
