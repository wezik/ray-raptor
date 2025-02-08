const std = @import("std");
const rlz = @import("raylib-zig");
const rayraptor = @import("src/lib.zig");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const rr_lib = b.addStaticLibrary(.{
        .name = "rayraptor-lib",
        .root_source_file = b.path("src/lib.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Get raylib dependency
    const raylib_dep = b.dependency("raylib-zig", .{
        .target = target,
        .optimize = optimize,
    });
    const raylib = raylib_dep.module("raylib");
    const raygui = raylib_dep.module("raygui");
    const raylib_artifact = raylib_dep.artifact("raylib");
    rr_lib.linkLibrary(raylib_artifact); // Merge raylib linkage

    rr_lib.root_module.addAnonymousImport("raylib", .{
        .root_source_file = raylib.root_source_file.?,
        .target = target,
        .optimize = optimize,
    });

    rr_lib.root_module.addAnonymousImport("raygui", .{
        .root_source_file = raygui.root_source_file.?,
        .target = target,
        .optimize = optimize,
    });

    const rr_mod = b.addModule("rayraptor", .{
        .root_source_file = b.path("src/lib.zig"),
        .target = target,
        .optimize = optimize,
    });
    rr_mod.addImport("raylib", raylib);
    rr_mod.addImport("raygui", raygui);

    b.installArtifact(rr_lib);
}
