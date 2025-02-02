const std = @import("std");
const rl = @import("raylib");
const lib = @import("lib.zig");

const LogLevel = enum {
    info,
    warn,
    err,
};

fn common(level: rl.TraceLogLevel, comptime format: []const u8, args: anytype) void {
    const input_msg = std.fmt.allocPrint(lib.allocator, format, args) catch unreachable;
    const result_msg = std.mem.Allocator.dupeZ(lib.allocator, u8, input_msg) catch unreachable;
    lib.allocator.free(input_msg);
    rl.traceLog(level, result_msg, .{});
    lib.allocator.free(result_msg);
}

pub fn info(comptime format: []const u8, args: anytype) void {
    common(.info, format, args);
}

pub fn warn(comptime format: []const u8, args: anytype) void {
    common(.warning, format, args);
}

pub fn err(comptime format: []const u8, args: anytype) void {
    common(.err, format, args);
}
