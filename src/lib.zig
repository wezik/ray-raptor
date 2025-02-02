const std = @import("std");
const rl = raylib;
const scene = @import("scene.zig");
const entities = @import("entity_system.zig");

// --- exposed components ---
pub const raylib = @import("raylib");

var gpa: std.heap.GeneralPurposeAllocator(.{}) = undefined;
/// Allocator used for all allocations internally
pub var allocator: std.mem.Allocator = undefined;

pub const Vec2 = rl.Vector2;
pub const Vec3 = rl.Vector3;
pub const Vec4 = rl.Vector4;
pub const Logger = @import("logger.zig");

// Scenes
pub const Scene = scene.Scene;
pub const registerScene = scene.registerScene;
pub const setActiveScene = scene.setActive;
const runScene = scene.run;

// Entities
pub const createEntity = entities.createEntity;

pub fn init() !void {
    gpa = std.heap.GeneralPurposeAllocator(.{}){};
    allocator = gpa.allocator();
}

fn deinit() !void {
    if (window_started) rl.closeWindow();
    try scene.deinit();
    entities.deinit();
    _ = gpa.deinit();
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

pub fn startDefault() !void {
    try start(.{});
}

var window_started: bool = false;
pub fn start(config: StartConfig) !void {
    // Initialize window
    rl.setWindowState(.{
        .window_resizable = config.window.resizable,
    });
    rl.initWindow(config.window.width, config.window.height, config.window.title);
    window_started = true;

    while (!gameShouldClose()) {
        try runScene();
    }

    try deinit();
}

var exit_signal: bool = false;
pub fn gameShouldClose() bool {
    if (exit_signal) return true;
    return rl.windowShouldClose();
}

pub fn exit() void {
    exit_signal = true;
}
