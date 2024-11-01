package game

import rl "../../raylib"

mouse_position: rl.Vector2
cursor_create :: proc() {

}
cursor_update :: proc() {
	mouse_position = rl.GetScreenToWorld2D(rl.GetMousePosition(), camera)


	if !is_player_dead {
		if mouse_position.x > players[current_active_player_index].position.x {
			players[current_active_player_index].is_flipped = false
		} else {
			players[current_active_player_index].is_flipped = true
		}
	}
}
cursor_draw :: proc() {}
cursor_draw_gui :: proc() {

}
