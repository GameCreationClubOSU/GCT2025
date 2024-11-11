shader_type canvas_item;
render_mode world_vertex_coords;

uniform vec4 line_color : source_color;
uniform float line_width : hint_range(0, 1) = 0.1;
uniform float grid_size = 16.0;

// VERTEX global in fragment refers to screen position
// Even with render_mode world_vertex_coords.
// So we need to save the world position from the vertex shader
// Yeah it's a bit goofy but it works
varying vec2 world_position;

void vertex() {
	world_position = VERTEX;
}

void fragment() {
	// https://bgolus.medium.com/the-best-darn-grid-shader-yet-727f9278b9d8
	vec2 lineAA = fwidth(world_position / grid_size);
	vec2 gridUV = 1.0 - abs(fract(world_position / grid_size) * 2.0 - 1.0);
	vec2 grid2 = smoothstep(line_width - lineAA, line_width + lineAA, gridUV);
	float grid = 1.0 - grid2.x * grid2.y;
	COLOR = mix(COLOR, line_color, grid);
}