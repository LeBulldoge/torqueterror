shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE, UV);


    if (all(lessThan(COLOR.rgb, vec3(0.2)))) {
        COLOR.rgb = vec3(sin(TIME + 1.0));
    }
}
