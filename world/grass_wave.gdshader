shader_type canvas_item;

uniform float speed = 2.0;
uniform float dis = 2.0;


void vertex( ){
	VERTEX.x += sin(TIME * speed) * dis * (UV.y-1.0);
}



//float noise(vec2 input){
	//return fract(sin(dot(input, vec2( 12.25, 10.356)) * 23.12) * 1054.52);
//}

//void fragment(){
	//float random = noise(UV);
	//COLOR = vec4(vec3(random), 0.3);
//}