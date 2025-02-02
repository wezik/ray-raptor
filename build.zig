const std = @import("std");
const rlz = @import("raylib-zig");
const rayraptor = @import("src/lib.zig");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Get raylib dependency
    const raylib_dep = b.dependency("raylib-zig", .{
        .target = target,
        .optimize = optimize,
    });
    const raylib = raylib_dep.module("raylib");
    const raylib_artifact = raylib_dep.artifact("raylib");

    const rr_lib = b.addStaticLibrary(.{
        .name = "rayraptor",
        .root_source_file = b.path("src/lib.zig"),
        .target = target,
        .optimize = optimize,
    });
    rr_lib.linkLibrary(raylib_artifact); // Merge raylib linkage
    rr_lib.root_module.addImport("raylib", raylib);
    b.installArtifact(rr_lib);

    // Expose rayraptor with raylib to consumers
    _ = b.addModule("rayraptor", .{
        .root_source_file = b.path("src/lib.zig"),
        .imports = &.{
            .{ .name = "raylib", .module = raylib },
        },
    });
}
