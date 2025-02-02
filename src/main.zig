const std = @import("std");
const rl = @import("raylib");

pub fn helloWorld() []const u8 {
    rl.initWindow(800, 450, "raylib [core] example - basic window");
    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        rl.clearBackground(rl.Color.white);
        rl.endDrawing();
    }
    return "Hello World!";
}
