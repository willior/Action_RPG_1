shader_type canvas_item;
render_mode blend_mix,unshaded;

void fragment() {
	COLOR.a = ceil(texture(TEXTURE, UV).a);
	}