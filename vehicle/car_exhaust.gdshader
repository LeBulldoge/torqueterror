shader_type canvas_item;

uniform sampler2D noise: repeat_enable;
uniform float speed;
uniform float noise_amount;

void fragment() {
	vec2 uv1 = vec2(UV.x + TIME * speed, UV.y);
   	vec2 uv2 = vec2(UV.x - TIME * speed, UV.y);
   	vec2 uv3 = vec2(UV.x, UV.y + TIME * speed);

    float noise_r = texture(noise, uv1).r;
    float noise_g = texture(noise, uv1).g;
    float noise_b = texture(noise, uv1).b;

    vec3 color = vec3(noise_r, noise_g, noise_b);
    float alpha = noise_r * noise_g * noise_b;

    COLOR.rgb = color;
    COLOR.a = clamp(alpha * noise_amount * texture(TEXTURE, UV).a, 0.0, 1.0);
}
