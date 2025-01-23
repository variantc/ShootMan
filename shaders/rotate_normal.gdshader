shader_type spatial;

uniform sampler2D normal_map;
uniform float angle = 0;
uniform vec3 camera_position = vec3(0.0, 0.0, 0.0);

void vertex() {
    // Get the current normal from the normal map
    vec3 normal = texture(normal_map, UV).xyz;

    // Calculate the rotation matrix based on the object's rotation
    mat2 rotation_matrix = mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));

    // Rotate the normal
    normal.xy = rotation_matrix * normal.xy;

    // Set the new normal vector
    NORMAL = normalize(VERTEX - camera_position) * mat3(TANGENT, BINORMAL, NORMAL) * normal;
}