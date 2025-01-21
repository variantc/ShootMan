shader_type canvas_item;

#include "res://shaders/characters.gdshaderinc"

#define BREATHING_PACE 4.0

void vertex() {
	breath(VERTEX, BREATHING_PACE); 		// characters.inc
}