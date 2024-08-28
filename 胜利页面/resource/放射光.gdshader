shader_type canvas_item;

/*
旋转奖励光效
*/

uniform float angle = 0.0;

vec2 customRotator(vec2 UVs,vec2 RotationCenter,float RotationAngle){
    //自定义旋转
    //RotationAngle为旋转输入0-1个值。值为1等于360度转弯。
    //RotationCenter输入一个数字作为旋转中心点。
    //UVs插入uv，世界坐标或其他值来旋转。
    vec2 _uv = UVs + RotationCenter * -1.0;
    float angle_cos = cos(RotationAngle);
    float angle_sin = sin(RotationAngle);
    vec2 _a = vec2(angle_cos, angle_sin * -1.0);
    vec2 _b = vec2(angle_sin, angle_cos);

    return vec2(dot(_uv, _a), dot(_uv, _b)) + RotationCenter;
}

void fragment() {
	vec2 uv = customRotator(UV,vec2(0.5),angle*TIME)-0.5;
	float r = length(uv);// 极径
	float a = atan(uv.x,uv.y); // 极角
	vec2 puv=vec2(a,r); // 转换为极坐标 puv.x 范围是 -pi ~ pi
	puv=vec2(puv.x/6.2831+.5,puv.y); // puv.x 范围是 0 ~ 1
	vec3 color=step(mod(puv.x,.17),0.08)*vec3(1);
	
	float mask = smoothstep(r,r+0.3,0.5)*color.r;
	
	COLOR = vec4(color,mask)*COLOR;
}
