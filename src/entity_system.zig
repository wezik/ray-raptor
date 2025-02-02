const std = @import("std");
const rl = @import("raylib");
const lib = @import("lib.zig");

pub const Entity = struct {
    uuid: [16]u8,
    name: []const u8,
    pos: rl.Vector2,
};

var entity_store: ?std.AutoArrayHashMap([16]u8, Entity) = null;

pub fn createEntity(name: []const u8, pos: rl.Vector2) !*Entity {
    if (entity_store == null) entity_store = std.AutoArrayHashMap([16]u8, Entity).init(lib.allocator);
    var em = entity_store.?;
    const uuid = createUUID();
    try em.put(uuid, .{
        .uuid = uuid,
        .name = name,
        .pos = pos,
    });
    return &em.get(uuid).?;
}

fn createUUID() [16]u8 {
    var uuid: [16]u8 = undefined;
    std.crypto.random.bytes(&uuid);
    uuid[6] = (uuid[6] & 0x0F) | 0x40; // Set version to 4 (random)
    uuid[8] = (uuid[8] & 0x3F) | 0x80; // Set variant to RFC 4122
    return uuid;
}

pub fn deinit() void {
    if (entity_store) |em| {
        em.deinit();
    }
}
