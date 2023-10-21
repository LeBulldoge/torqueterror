shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE, UV);
    COLOR.g += 0.6;
    COLOR.r -= 0.4;
}
