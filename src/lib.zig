const std = @import("std");
const rl = raylib;
const scene_system = @import("core/scene_system.zig");
const engine = @import("engine.zig");

// --- exposed components ---
pub const raylib = @import("raylib");

pub const Vec2 = rl.Vector2;
pub const Vec3 = rl.Vector3;
pub const Vec4 = rl.Vector4;
pub const Logger = @import("logger.zig");

// Engine

/// Starts the gameloop
pub fn start() !void {
    try e.start();
}

/// Returns the delta time
pub fn deltaTime() f32 {
    return e.deltaTime();
}

/// Returns the fixed delta time
pub fn fixedDeltaTime() f32 {
    return e.fixedDeltaTime();
}

/// Returns the number of fixed cycles you should run in your fixed update
pub fn fixedCycles() usize {
    return e.fixedCycles();
}

/// Triggers the engine to exit
pub fn exit() void {
    e.exit();
}

// Scenes
pub const Scene = scene_system.Scene;
pub const SceneManager = scene_system.SceneManager;
pub const Scenes = struct {
    pub fn register(scene: Scene) !void {
        try e.scene_manager.register(scene);
    }

    pub fn queue(name: []const u8) !void {
        try e.scene_manager.queue(name);
    }
};

// Entities

// Engine internals
var e: engine.RayRaptor = undefined;
var gpa: std.heap.GeneralPurposeAllocator(.{}) = undefined;
pub var allocator: std.mem.Allocator = undefined;

// Init RayRaptor engine, required to use the engine
pub fn init() !void {
    gpa = std.heap.GeneralPurposeAllocator(.{}){};
    allocator = gpa.allocator();
    e = engine.RayRaptor.init(allocator);
}

pub const StartConfig = struct {
    window: WindowConfig = .{},
};

pub const WindowConfig = struct {
    title: [*:0]const u8 = "Ray Raptor",
    width: i32 = 800,
    height: i32 = 600,
    resizable: bool = false,
};

// var window_started: bool = false;
// pub fn start(config: StartConfig) !void {
//     // Initialize window
//     rl.setWindowState(.{
//         .window_resizable = config.window.resizable,
//     });
//     rl.initWindow(config.window.width, config.window.height, config.window.title);
//     window_started = true;
//
//     while (!gameShouldClose()) {
//         try runScene();
//     }
//
//     try deinit();
// }
//
// var exit_signal: bool = false;
// pub fn gameShouldClose() bool {
//     if (exit_signal) return true;
//     return rl.windowShouldClose();
// }
//
// pub fn exit() void {
//     exit_signal = true;
// }
