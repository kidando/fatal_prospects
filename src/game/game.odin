package game

import rl "../../raylib"


draw :: proc() {
	_screen_height := f32(rl.GetScreenHeight())
	camera.zoom = _screen_height / WORLD_SIZE.y
	camera.offset = {f32(rl.GetScreenWidth() / 2), _screen_height / 2}
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
	rl.BeginMode2D(camera)
	game_draw()
	rl.EndMode2D()
	game_draw_gui()
	rl.EndDrawing()
}

init :: proc() {
	// Create
}

update :: proc() {
	// Input and Update
}

game_draw::proc(){
	// Draw inside camera
}

game_draw_gui::proc(){
	// Draw after camera (GUI)
}