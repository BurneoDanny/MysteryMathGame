shader_type canvas_item;

uniform sampler2D magnified_texture;  // Textura del SubViewport (zoom)
uniform vec2 glass_center;  // Posición de la lupa en la pantalla
uniform float radius = 50.0;  // Tamaño del cristal de la lupa
uniform vec2 screen_size;  // Tamaño de la pantalla

void fragment() {
    vec2 uv = SCREEN_UV;
    
    // Distancia desde el centro de la lupa
    float dist = distance(uv * screen_size, glass_center);
    
    // Si está dentro del radio, usar la textura ampliada
    if (dist < radius) {
        vec2 zoom_uv = (glass_center / screen_size) + (uv - 0.5) * 0.5;
        COLOR = texture(magnified_texture, zoom_uv);
    } else {
        COLOR = texture(TEXTURE, uv);  // Muestra la imagen normal de la lupa
    }
}
