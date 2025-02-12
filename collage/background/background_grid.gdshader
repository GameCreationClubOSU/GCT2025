shader_type canvas_item;
render_mode skip_vertex_transform;

uniform vec4 line_color : source_color;
uniform float line0_width : hint_range(0, 0.5) = 0.1;
uniform float line1_width : hint_range(0, 0.5) = 0.1;
uniform float grid0_size = 16.0;
uniform float grid1_size = 64.0;

// VERTEX global in fragment refers to screen position
// Even with render_mode world_vertex_coords.
// So we need to save the world position from the vertex shader
// Yeah it's a bit goofy but it works
varying vec2 world_position;

void vertex() {
	mat4 inv = inverse(CANVAS_MATRIX) * inverse(SCREEN_MATRIX);
	// * 2 here is because the gradient texture generates a texture 1 pixel tall
	// Screen space is from -1 to 1 so we need a 2x2 
	VERTEX = (inv * vec4(VERTEX * 2.0, 0, 1)).xy;
	// Note: You should need to apply the model transform here, but you don't?
	// Not sure why but it works so whatever.
	world_position = VERTEX;
}

float grid(float width, vec2 uv) {
	vec2 uvDeriv = fwidth(uv);

    vec2 drawWidth = clamp(vec2(width), uvDeriv, vec2(0.5));
    vec2 gridUV = abs(fract(uv) * 2.0 - 1.0);
	gridUV = vec2(1) - gridUV;

    vec2 grid2 = smoothstep(drawWidth + uvDeriv, drawWidth - uvDeriv, gridUV);
	//COLOR = vec4((drawWidth + lineAA).x * 5.0, 0.0, 0.0, 1.0);
    grid2 *= clamp(width / drawWidth, 0.0, 1.0);
    grid2 = mix(grid2, vec2(width), clamp(uvDeriv * 2.0 - 1.0, 0.0, 1.0));

	return mix(grid2.x, 1.0, grid2.y);
}

void fragment() {
	vec2 uv0 = world_position / grid0_size;
	vec2 uv1 = world_position / grid1_size;

	COLOR = mix(COLOR, line_color, max(grid(line0_width, uv0), grid(line1_width, uv1)));
}