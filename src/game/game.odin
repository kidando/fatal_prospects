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
	snd_mine = rl.LoadSound("../../assets/sounds/snd_mine.wav")
	snd_level_up = rl.LoadSound("../../assets/sounds/snd_level_up.wav")
	snd_rock_break = rl.LoadSound("../../assets/sounds/snd_break_rock.wav")
	snd_choose_upgrade = rl.LoadSound("../../assets/sounds/snd_choose_upgrade.wav")
	snd_upgrade_selected = rl.LoadSound("../../assets/sounds/snd_upgrade_selected.wav")
	snd_ouch = rl.LoadSound("../../assets/sounds/snd_ouch.wav")
	mus_desert = rl.LoadMusicStream("../../assets/mus/snd_desert.ogg")
	snd_player_hurt = rl.LoadSound("../../assets/sounds/snd_player_hurt.wav")
	snd_game_over = rl.LoadSound("../../assets/sounds/snd_game_over.wav")
	snd_strike_bell = rl.LoadSound("../../assets/sounds/snd_strike_bell.wav")
	if DEBUG_MODE {
		debug_create()
	}
	level_main_create()
	obj_player_create()
	obj_gold_deposit_create()
	upgrades_menu_create()
	upgrades_create()
	cursor_create()
	enemies_create()
	main_menu_create()
	rl.PlayMusicStream(mus_desert)
}

update :: proc() {
	rl.UpdateMusicStream(mus_desert)
	// Input and Update
	if DEBUG_MODE {
		debug_update()
	}
	level_main_update()
	obj_player_update()
	obj_gold_deposit_update()
	upgrades_menu_update()
	upgrades_update()
	enemies_update()
	cursor_update()
	game_over_update()
	main_menu_update()

	if current_state != .GAME_OVER && current_state != .MAIN_MENU{
		if time_min > 0 {
			time_timer += rl.GetFrameTime()
			if time_timer >= time_timer_duration {
				time_timer = 0
				time_sec -= 1
				if time_sec < 0 {
					time_min -= 1
					time_sec = 59
					enemies_update_wave()
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
						enemies_update_wave()
					}
				}
			}
		}
	}

	

}

game_draw :: proc() {
	// Draw inside camera
	level_main_draw()
	obj_gold_deposit_draw()
	upgrades_draw()
	enemies_draw()
	obj_player_draw()

	main_menu_draw()


	upgrades_menu_draw()
	if DEBUG_MODE {
		debug_draw()
	}
	cursor_draw()

}

game_draw_gui :: proc() {
	// Draw after camera (GUI)
	level_main_draw_gui()
	obj_player_draw_gui()
	obj_gold_deposit_draw_gui()
	upgrades_draw_gui()

	hud_draw_gui()
	upgrades_menu_draw_gui()

	if DEBUG_MODE {
		debug_draw_gui()
	}
	enemies_draw_gui()
	game_over_draw_gui()
	main_menu_draw_gui()

	cursor_draw_gui()
}
