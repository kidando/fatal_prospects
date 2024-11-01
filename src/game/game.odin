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
	fnt_main = rl.LoadFont("../../assets/images/fnt_romulus.png")
	snd_revolver = rl.LoadSound("../../assets/sounds/snd_revolver.wav")
	if DEBUG_MODE {
		debug_create()
	}
	level_main_create()
	obj_player_create()
	cursor_create()
}

update :: proc() {
	// Input and Update
	if DEBUG_MODE {
		debug_update()
	}
	level_main_update()
	obj_player_update()
	cursor_update()


	if time_min > 0 {
		time_timer += rl.GetFrameTime()
		if time_timer >= time_timer_duration {
			time_timer = 0
			time_sec -= 1
			if time_sec < 0 {
				time_min -= 1
				time_sec = 59
			}
		}
	} else {
		if time_sec > 0 {
			time_timer += rl.GetFrameTime()
			if time_timer >= time_timer_duration {
				time_timer = 0
				time_sec -= 1
				if time_sec < 0 {
					time_min -= 1
					time_sec = 59
				}
			}
		}
	}

}

game_draw :: proc() {
	// Draw inside camera
	level_main_draw()
	obj_player_draw()


	if DEBUG_MODE {
		debug_draw()
	}
	cursor_draw()

}

game_draw_gui :: proc() {
	// Draw after camera (GUI)
	level_main_draw_gui()
	obj_player_draw_gui()

	hud_draw_gui()

	if DEBUG_MODE {
		debug_draw_gui()
	}
	cursor_draw_gui()
}
