const std = @import("std");
// const rlz = @import("raylib-zig");
const rayraptor = @import("src/main.zig");

pub fn build(b: *std.Build) !void {
    _ = b.addModule("rayraptor", .{
        .root_source_file = b.path("src/main.zig"),
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });

    // const raylib_dep = b.dependency("raylib-zig", .{
    //     .target = target,
    //     .optimize = optimize,
    // });
    //
    // const raylib = raylib_dep.module("raylib");
    // const raylib_artifact = raylib_dep.artifact("raylib");
    //
    // const engine_lib = b.addModule("zig-raptor", .{
    //     .root_source_file = b.path("src/main.zig"),
    //     .dependencies = &.{raylib_dep},
    // });
    //
    // engine_lib.addImport("raylib", raylib);
    // b.installArtifact(raylib_artifact);
}
