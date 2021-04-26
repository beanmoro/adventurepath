shader_type canvas_item;

varying vec2 world_pos;
uniform mat4 global_transform;
uniform float speed = 1.0;
uniform float amplitud = 5.0;

void vertex(){

	world_pos = (global_transform * vec4(VERTEX, 0.0, 1.0)).xy;
	
	if (VERTEX.y < 1.0) {
		VERTEX.x += sin((TIME*speed)+world_pos.y)*amplitud;
	}
	
}