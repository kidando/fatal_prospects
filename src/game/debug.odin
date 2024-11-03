package game

import rl "../../raylib"

// CONSTANTS
DEBUG_MODE::false
DEBUG_COLLIDER_OPACITY::100
// VARIABLES
debug_show_colliders:bool = false

debug_create::proc(){

}

debug_update::proc(){
	// INPUTS
	if rl.IsKeyPressed(.KP_0){
		debug_show_colliders = !debug_show_colliders
	}
}

debug_draw::proc(){

}

debug_draw_gui::proc(){
	
}