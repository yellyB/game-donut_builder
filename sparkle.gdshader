shader_type canvas_item;

uniform bool active = true;
uniform float sparkle_speed = 0.5;
uniform float sparkle_density = 0.95; // 0.0 to 1.0, higher means fewer sparkles
uniform float sparkle_intensity = 3.0;
uniform float sparkle_size = 80.0; // Lower value means bigger sparkles

// 2D pseudo-random function
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
    // Get the original color from the sprite's texture
    vec4 original_color = texture(TEXTURE, UV);

    if (active) {
        // Floor the UVs by the sparkle size to create larger "pixels" or blocks
        vec2 blocks = floor(UV * sparkle_size) / sparkle_size;
        
        // Create a random value that changes over time based on the block, not the pixel
        float rnd = random(blocks + TIME * sparkle_speed);

        // If the random value is above the density threshold, create a sparkle
        if (rnd > sparkle_density) {
            float sparkle = (rnd - sparkle_density) / (1.0 - sparkle_density);
            original_color.rgb += vec3(sparkle * sparkle_intensity);
        }
    }

    // Set the final pixel color
    COLOR = original_color;
}