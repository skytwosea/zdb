const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});


    // DEPENDENCIES
    // ------------
    const libzdb_dependency = b.dependency("libzdb", .{
        .target = target,
        .optimize = optimize,
    });
    const libzdb_module = libzdb_dependency.module("libzdb");

    const libedit = b.addStaticLibrary(.{
        .name = "libedit",
        .root_source_file = b.path("pkg/libedit/libedit.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(libedit);


    // EXECUTABLE
    // ----------
    const exe = b.addExecutable(.{
        .name = "zdb",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("libzdb", libzdb_module);
    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);


    // TESTING
    // -------
    // const _exe_module = b.createModule(.{.root_source_file = b.path("src/main.zig")});
    // const _libzdb_module = b.createModule(.{.root_source_file = b.path("include/libzdb.zig")});
    // module decls: see docs for std.Build.TestOptions at  https://ziglang.org/documentation/master/std/#std.Build.TestOptions
    // std.Build.addTest() is supposed to use field `root_module` but this is unavailable?

    const exe_unit_tests = b.addTest(.{
        .name = "exe unit tests",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const libzdb_unit_tests = b.addTest(.{
        .name = "libzdb unit tests",
        .root_source_file = b.path("include/libzdb.zig"),
        .target = target,
        .optimize = optimize,
    });
    const libedit_unit_tests = b.addTest(.{
        .name = "libedit tests",
        .root_source_file = b.path("pkg/libedit/libedit.zig"),
        .target = target,
        .optimize = optimize,
    });

    libedit_unit_tests.linkSystemLibrary("c");
    libedit_unit_tests.linkSystemLibrary("libedit");

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);
    const run_libzdb_unit_tests = b.addRunArtifact(libzdb_unit_tests);
    const run_libedit_unit_tests = b.addRunArtifact(libedit_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
    test_step.dependOn(&run_libzdb_unit_tests.step);
    test_step.dependOn(&run_libedit_unit_tests.step);
}
