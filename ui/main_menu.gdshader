shader_type canvas_item;


void fragment() {
    float d = distance(vec2(0.5), UV) * (sin(TIME) + 0.2);
    COLOR = mix(vec4(0.2, 0.0, 0.0, 0.0), vec4(0.0, 0.0, 0.0, 1.0), d);
}
