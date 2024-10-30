package game

import rl "../../raylib"


cursor_create :: proc() {

}
cursor_update :: proc() {
	mouse_position := rl.GetScreenToWorld2D(rl.GetMousePosition(), camera)
	

	if !is_player_dead {
		for &_player in players {
			if _player.is_active {
				
				if mouse_position.x > _player.position.x{
					_player.is_flipped = false
				}else{
					_player.is_flipped = true
				}
			}
		}
	}
}
cursor_draw :: proc() {}
cursor_draw_gui :: proc() {
	
}
