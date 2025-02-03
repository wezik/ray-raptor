const rr = @import("rayraptor");
const rl = rr.raylib;

const default_fps: usize = 240;
var cycles: usize = 0;
var fixed_cycles: usize = 0;

pub fn main() !void {
    // initialize rayraptor
    try rr.init();

    // set scenes
    try rr.Scenes.register(.{
        .name = "fixed_update",
        .update_step = update,
    });
    try rr.Scenes.queue("fixed_update");

    // start the engine
    rl.setTargetFPS(default_fps);
    try rr.start();
}

fn update(_: *rr.Scene) !void {
    // count cycles for normal and fixed updates
    cycles += 1;
    for (rr.fixedCycles()) |_| fixed_cycles += 1;

    // toggle target fps
    if (rl.isKeyPressed(.space)) {
        rl.setTargetFPS(30);
    }
    if (rl.isKeyReleased(.space)) {
        rl.setTargetFPS(default_fps);
    }

    // draw scene
    rl.beginDrawing();

    rl.clearBackground(rl.Color.black);

    const delta_x = rl.math.wrap(@floatFromInt(cycles), 10, 810);
    const fixed_x = rl.math.wrap(@floatFromInt(fixed_cycles), 10, 810);

    rl.drawCircleV(.{ .x = delta_x, .y = 60 }, 20, rl.Color.red);
    rl.drawCircleV(.{ .x = fixed_x, .y = 120 }, 20, rl.Color.blue);

    rl.endDrawing();
}
