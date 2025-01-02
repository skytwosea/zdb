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

    // EXECUTABLE
    // ----------
    const elf = b.addExecutable(.{
        .name = "zdb",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    elf.root_module.addImport("libzdb", libzdb_module);
    b.installArtifact(elf);
    const run_cmd = b.addRunArtifact(elf);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);


    // TESTING
    // -------
    // const _elf_module = b.createModule(.{.root_source_file = b.path("src/main.zig")});
    // const _libzdb_module = b.createModule(.{.root_source_file = b.path("include/libzdb.zig")});
    // module decls: see docs for std.Build.TestOptions at  https://ziglang.org/documentation/master/std/#std.Build.TestOptions
    // std.Build.addTest() is supposed to use field `root_module` but this is unavailable?
    const elf_unit_tests = b.addTest(.{
        .name = "elf unit tests",
        // .root_module = _elf_module,
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const lib_unit_tests = b.addTest(.{
        .name = "lib unit tests",
        // .root_module = _libzdb_module,
        .root_source_file = b.path("include/libzdb.zig"),
        .target = target,
        .optimize = optimize,
    });
    const run_elf_unit_tests = b.addRunArtifact(elf_unit_tests);
    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_elf_unit_tests.step);
    test_step.dependOn(&run_lib_unit_tests.step);
}
