shader_type canvas_item;

/*
一个白色圆环用于粒子特效
*/
uniform float width = 0.1;

void fragment() {
	float d = length(UV-0.5);
	d = smoothstep(d,d+0.01,0.5);
	float a = length(UV-0.5);
	a = smoothstep(a,a+0.01,0.5-width);
	d = d-a;
	COLOR = COLOR * vec4(1.0,1.0,1.0,d);
}