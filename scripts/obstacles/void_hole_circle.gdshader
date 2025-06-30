shader_type canvas_item;

// Core circle properties
uniform float core_radius : hint_range(0.0, 0.5) = 0.4;
uniform vec4 core_color : source_color = vec4(0.0, 0.0, 0.0, 1.0); // Black hole
uniform float edge_softness : hint_range(0.001, 0.2) = 0.02;

// Glow properties
uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // White glow
uniform float glow_radius : hint_range(0.0, 1.0) = 0.5;
uniform float glow_intensity : hint_range(0.0, 10.0) = 1.5;
uniform float glow_falloff : hint_range(0.01, 1.0) = 0.1;

void fragment() {
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(UV, center);
    
    // Core circle with soft edge
    float core_alpha = smoothstep(core_radius, core_radius - edge_softness, dist);
    vec4 core = core_color * core_alpha;
    
    // Glow effect
    float glow_alpha = 1.0 - smoothstep(glow_radius - glow_falloff, glow_radius, dist);
    glow_alpha *= (1.0 - core_alpha); // Don't overlap glow on core
    vec4 glow = glow_color * glow_intensity * glow_alpha;
    
    // Combine effects
    COLOR = core + glow;
}
