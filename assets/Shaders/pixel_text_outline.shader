shader_type canvas_item;

void fragment() {
	COLOR.a = ceil(texture(TEXTURE, UV).a);
	}