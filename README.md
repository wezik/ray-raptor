# Ray Raptor Game engine
This game engine is built on top of [zig bindings for raylib](https://github.com/Not-Nik/raylib-zig) it's goal is to introduce opinionated implementation of systems raylib doesn't provide.

Current state is extremely work in progress and until 1.0 below features are to be considered incomplete.
## Currently the goal is to introduce:
- Scene management
- Entity management
- 2D Physics engine
- 2D Sprite manipulation
- State machine
- Audio Storage with caching
- Texture Storage with caching
- Fixed update handling

## How to use
To add to your project, fetch current `#HEAD` / `#<TAG>` / `#<COMMIT-SHA>` via `zig fetch --save` for example:  
`zig fetch --save git+https://github.com/wezik/ray-raptor/#0.1.0`

then define the dependency and import it in your `build.zig` for example:
```zig
// inside build step

// define dependency, module and artifact
const rr_dep = b.dependency("rayraptor", .{
  .target = target,
  .optimize = optimize,
});
const rr_mod = rr_dep.module("rayraptor");
const rr_artifact = rr_dep.artifact("rayraptor-lib")

// link rayraptor to your executable
// const exe = b.addExecutable(...) // your executable
exe.root_module.addImport("rayraptor", rr_mod); // add import
exe.linkLibrary(rr_artifact); // link artifact
```
