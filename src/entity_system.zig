const std = @import("std");
const rl = @import("raylib");

pub const Entity = struct {
    uuid: [16]u8,
    name: []const u8,
    pos: rl.Vector2,
};

pub const EntityManager = struct {
    allocator: std.mem.Allocator,
    entities: std.AutoArrayHashMap([16]u8, Entity),

    pub fn init(allocator: std.mem.Allocator) EntityManager {
        return EntityManager{
            .allocator = allocator,
            .entities = std.AutoArrayHashMap([16]u8, Entity).init(allocator),
        };
    }

    pub fn deinit(self: *EntityManager) void {
        self.entities.deinit();
    }

    pub fn create(self: *EntityManager, name: []const u8, pos: rl.Vector2) !*Entity {
        // generate UUID
        var uuid: [16]u8 = undefined;
        std.crypto.random.bytes(&uuid);
        uuid[6] = (uuid[6] & 0x0F) | 0x40; // Set version to 4 (random)
        uuid[8] = (uuid[8] & 0x3F) | 0x80; // Set variant to RFC 4122
        // create entity
        var e = Entity{
            .uuid = uuid,
            .name = name,
            .pos = pos,
        };
        try self.entities.put(uuid, e);
        return &e;
    }
};
