const std = @import("std");
const lib = @import("lib.zig");
const rl = @import("raylib");
const Logger = @import("logger.zig");

pub const Scene = struct {
    name: []const u8,
    initFn: ?*const fn () anyerror!void = null,
    updateFn: ?*const fn (f32) anyerror!void = null,
    fixedUpdateFn: ?*const fn (f32) anyerror!void = null,
    drawFn: ?*const fn () anyerror!void = null,
    deinitFn: ?*const fn () anyerror!void = null,
};

var scene_store: ?std.StringArrayHashMap(Scene) = null;
var active_scene: ?*Scene = null;

/// Registers a scene with the engine
pub fn registerScene(scene: Scene) !void {
    if (scene_store == null) scene_store = std.StringArrayHashMap(Scene).init(lib.allocator);
    try scene_store.?.put(scene.name, scene);
}

// fixed delta time for scenes, will be configurable later
var fdt: f32 = 1.0 / 128.0;
var delta_time_ticker: f32 = 0;

/// Runs the active scene
pub fn run() !void {
    if (scene_store == null) {
        Logger.err("SCENE: No scenes registered", .{});
        return error.NoScenesRegistered;
    }
    if (active_scene == null) try setActive(scene_store.?.keys()[0]);
    const as = active_scene.?;

    // update phase
    const dt = rl.getFrameTime();
    if (as.updateFn) |update| try update(dt);

    // fixed update phase
    delta_time_ticker += dt;
    while (delta_time_ticker >= fdt) {
        delta_time_ticker -= fdt;
        if (as.fixedUpdateFn) |fixedUpdate| try fixedUpdate(fdt);
    }

    // draw phase
    rl.beginDrawing();
    rl.clearBackground(rl.Color.black);
    if (as.drawFn) |draw| try draw();
    rl.endDrawing();
}

/// Sets the active scene, deinits the previous one if exists, and inits the new one
pub fn setActive(name: []const u8) !void {
    if (scene_store == null) {
        Logger.err("SCENE: No scenes registered", .{});
        return error.NoScenesRegistered;
    }

    if (active_scene) |scene| if (scene.deinitFn) |deinit_fn| try deinit_fn();
    active_scene = scene_store.?.getPtr(name) orelse {
        Logger.err("SCENE: Scene with name '{s}' does not exist", .{name});
        return error.SceneNotRegistered;
    };
    if (active_scene.?.initFn) |init_fn| try init_fn();
    delta_time_ticker = 0;
}

/// Only for internal use, deinits the map of registered scenes, as well as the active scene
pub fn deinit() !void {
    if (active_scene) |scene| if (scene.deinitFn) |deinit_fn| try deinit_fn();
    if (scene_store) |*ss| {
        ss.clearAndFree();
        ss.deinit();
    }
}
