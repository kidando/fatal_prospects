package game

import rl "../../raylib"

Rect :: rl.Rectangle
Vec2 :: [2]f32
Vec2i :: [2]i32

GameState :: struct {
	player_pos: Vec2,
}

g_state: ^GameState

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

create :: proc() {
	// Create
	tex_tileset = rl.LoadTexture("../../assets/images/tex_tileset.png")

	obj_player_create()
}

update :: proc() {
	// Input and Update
	obj_player_update()
}

game_draw::proc(){
	// Draw inside camera
	obj_player_draw()
	
}

game_draw_gui::proc(){
	// Draw after camera (GUI)
	obj_player_draw_gui()
}