const std = @import("std");
const rlz = @import("raylib-zig");
const rayraptor = @import("src/main.zig");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const rr_mod = b.addModule("rayraptor", .{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const raylib_dep = b.dependency("raylib-zig", .{
        .target = target,
        .optimize = optimize,
    });

    const raylib = raylib_dep.module("raylib");

    rr_mod.addImport("raylib", raylib);

    // dev build setup (it's needed to link the raylib library for development)
    const raylib_artifact = raylib_dep.artifact("raylib");

    const develop_step = b.step("develop", "Development setup");
    const dummy_exe = b.addExecutable(.{
        .name = "rayraptor_dev",
        .root_source_file = b.path("src/dummy.zig"),
        .target = target,
        .optimize = optimize,
    });

    dummy_exe.root_module.addImport("rayraptor", rr_mod);
    dummy_exe.root_module.addImport("raylib", raylib);
    dummy_exe.linkLibrary(raylib_artifact);
    develop_step.dependOn(&b.addInstallArtifact(dummy_exe, .{}).step);
    // end of dev build setup

    b.installArtifact(raylib_artifact);
}
