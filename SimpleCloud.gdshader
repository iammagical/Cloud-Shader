shader_type spatial;
render_mode depth_prepass_alpha, cull_back, blend_mix, diffuse_toon, specular_toon;

group_uniforms Clouds;
uniform vec4 color: source_color;
uniform sampler2D noise_texture;
uniform sampler2D noise_normal_texture;

uniform sampler2D cloud_texture;
uniform float time_scale: hint_range(0.0, 5.0, 0.01);
uniform float cloud_step: hint_range(0.01, 1.0, 0.01);


group_uniforms Height;
uniform float noise_height;

void vertex() {
	//Basic billboarding and "Keep Scale" snippet from Godot's StandardMaterial3D Shader so you can use it with the GPUParticle3D node
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0), vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0), vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0), vec4(0.0, 0.0, 0.0, 1.0));
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	
	//Offsets height of quad's vertices using noise_texture
	float height = texture(noise_texture, VERTEX.xy/ 2.0 + 0.5 + TIME * -time_scale * 0.5).x;
	height = (height * noise_height);
	VERTEX.z += height;
}

group_uniforms lighting;
uniform vec3 normal_bias = vec3(0.0);
uniform vec3 light_bias = vec3(0.0);
uniform float shadow_size = 0.045;
uniform float shadow_blend = 0.001;
uniform float shadow_extra_intensity = 0.0;
uniform vec4 shadow_color: source_color;
uniform vec4 light_tint : source_color;

void light(){
	
	//A modified snippit of NekoArts' Botw shader https://godotshaders.com/shader/update-botw-toon-shader/
	float NdotL = dot(NORMAL + normal_bias, LIGHT + light_bias);
	float rounded = smoothstep(shadow_size, shadow_blend + shadow_size, NdotL);
	float one_minus = 1.0 - rounded;

	float diffuse_normal_mask = mix(0.0, 1.0, rounded);
	diffuse_normal_mask = 1.0 - diffuse_normal_mask;
	
	vec3 final_diffuse;
	float shadow_mask = (1.0 - ATTENUATION);
	
	float combined_shadow = clamp(0.0, 1.0, shadow_mask + diffuse_normal_mask);
	
	vec3 final_shadow = mix(vec3(1.0), (combined_shadow * shadow_color.rgb) - shadow_extra_intensity, combined_shadow);
	
	vec3 final_color = mix( LIGHT_COLOR * light_tint.rgb, final_shadow,combined_shadow);
	
	DIFFUSE_LIGHT = final_color;
}

void fragment() {
	vec4 noise = texture(noise_texture, UV + TIME * -time_scale);
	vec4 normal = texture(noise_normal_texture, UV + TIME * -time_scale);
	vec4 cloud = texture(cloud_texture, UV);
	
	float cloud_mask = smoothstep(0.0, 1.0, cloud.r);
	ALBEDO = color.rgb;
	NORMAL = normal.rgb;
	noise.a = mix(0.0, 1.0, noise.r);
	
	ALPHA = smoothstep(0.0, cloud_step, (cloud.a * noise.a)) * COLOR.a;
}

