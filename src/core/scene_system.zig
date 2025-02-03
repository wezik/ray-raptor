const std = @import("std");

pub const SceneManager = struct {
    scenes: std.StringArrayHashMap(Scene),
    active_scene: ?*Scene = null,
    queued_scene: ?*Scene = null,

    pub fn init(allocator: std.mem.Allocator) SceneManager {
        return SceneManager{
            .scenes = std.StringArrayHashMap(Scene).init(allocator),
        };
    }

    pub fn deinit(self: *SceneManager) !void {
        if (self.active_scene) |scene| try scene.deinit();
        if (self.queued_scene) |scene| try scene.deinit();
        self.scenes.deinit();
    }

    /// Registers a scene in scene management system
    pub fn register(self: *SceneManager, scene: Scene) !void {
        try self.scenes.put(scene.name, scene);
    }

    /// This will queue next scene and init it in the next cycle, if it can't find a scene it will error
    pub fn queue(self: *SceneManager, name: []const u8) !void {
        self.queued_scene = self.scenes.getPtr(name) orelse return error.SceneNotFound;
    }

    /// Runs the scene cycle, and swaps the scenes if next is queued up
    pub fn run(self: *SceneManager) !void {
        // run active scene
        if (self.active_scene) |as| {
            try as.update();
        }

        // change scenes if next one is queued_up
        if (self.queued_scene) |qs| {
            if (self.active_scene) |as| try as.deinit();
            try qs.init();
            self.active_scene = qs;
            self.queued_scene = null;
        }
    }
};

pub const Scene = struct {
    name: []const u8,
    init_step: ?*const fn (*Scene) anyerror!void = null,
    deinit_step: ?*const fn (*Scene) anyerror!void = null,
    update_step: ?*const fn (*Scene) anyerror!void = null,
    ctx: ?*anyopaque = null,

    pub fn init(self: *Scene) !void {
        if (self.init_step) |_fn| try _fn(self);
    }

    pub fn deinit(self: *Scene) !void {
        if (self.deinit_step) |_fn| try _fn(self);
    }

    pub fn update(self: *Scene) !void {
        if (self.update_step) |_fn| try _fn(self);
    }
};
