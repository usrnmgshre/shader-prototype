*** this is purely just for me (usernamegoeshere) to write down notes and stuff as i learn how to code shaders lol

## Passing
- Varyings (or `out` [vsh] and `in` [fsh] in newer GLSL versions) are used to pass data between stages of the same program, i.e. `shadow.vsh` -> `shadow.fsh`
- Textures/buffers are used to pass data between different programs, i.e. `glbuffers_terrain.vsh` -> `composite.fsh`
	> Textures/buffers such as `colortex0`, `shadowtex0`, etc. are basically just `vec4` variables that can be accessed by *most* programs
	> To assign data to textures/buffers, use comment `/* DRAWBUFFERS:NNNN */` which tells Optifine/Iris to apply that data to texture/buffer of choice

## Planned features
- SSAO
- Volumetric lighting
- Specular highlight + water reflection
- Water foam effect
- Post processing FX (bloom, FXAA/TAA, DOF, motion blur, etc.)