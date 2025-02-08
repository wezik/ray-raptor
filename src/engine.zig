const std = @import("std");
const rl = @import("raylib");
const s_sys = @import("core/scene_system.zig");

pub const RayRaptor = struct {
    scene_manager: s_sys.SceneManager,

    fixed_ticker: f32 = 0.0,
    fixed_cycles: usize = 0,
    fixed_delta_time: f32 = 1.0 / 128.0,

    exit_signal: bool = false,

    pub fn init(allocator: std.mem.Allocator) RayRaptor {
        rl.initWindow(800, 600, "Ray Raptor Engine");
        return .{
            .scene_manager = s_sys.SceneManager.init(allocator),
        };
    }

    fn deinit(self: *RayRaptor) !void {
        try self.scene_manager.deinit();
    }

    pub fn start(self: *RayRaptor) !void {
        // run the game loop
        while (!self.exit_signal) {
            // calculate fixed cycles to run
            self.fixed_ticker += rl.getFrameTime();
            self.fixed_cycles = 0;
            while (self.fixed_ticker >= self.fixed_delta_time) {
                self.fixed_ticker -= self.fixed_delta_time;
                self.fixed_cycles += 1;
            }
            // run current scene
            try self.scene_manager.run();

            // check for window close
            if (rl.windowShouldClose()) self.exit_signal = true;
        }

        // stop the engine
        rl.closeWindow();
        try self.deinit();
    }

    pub fn deltaTime(_: *RayRaptor) f32 {
        return rl.getFrameTime();
    }

    pub fn fixedDeltaTime(self: *RayRaptor) f32 {
        return self.fixed_delta_time;
    }

    pub fn fixedCycles(self: *RayRaptor) usize {
        return self.fixed_cycles;
    }

    pub fn exit(self: *RayRaptor) void {
        self.exit_signal = true;
    }
};
