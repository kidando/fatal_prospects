package game

import rl "../../raylib"

hud_create :: proc() {

}
hud_update :: proc() {}
hud_draw :: proc() {}

hud_draw_gui :: proc() {
	if current_state != .GAME_OVER && current_state != .MAIN_MENU {
		hud_lvl_bar_outter_buffer: i32 = 256
		hud_lvl_bar_outter_width := i32(WINDOW_SIZE.x) - hud_lvl_bar_outter_buffer

		top_anchor_pos_y: f32 = WINDOW_SIZE.y - 48

		rl.DrawRectangle(
			i32(hud_lvl_bar_outter_buffer / 2),
			i32(top_anchor_pos_y),
			hud_lvl_bar_outter_width,
			24,
			{32, 32, 32, 255},
		)

		_progress_bar := f32(hud_lvl_bar_outter_width - 4) * f32(xp) / f32(xp_max)
		rl.DrawRectangle(
			i32(hud_lvl_bar_outter_buffer / 2) + 2,
			i32(top_anchor_pos_y) + 2,
			i32(_progress_bar),
			20,
			{246, 205, 38, 255},
		)

		_level_text: cstring = rl.TextFormat("LEVEL %d", level)
		_level_text_font_size: f32 = 24
		_level_text_font_spaceing: f32 = 4.0
		_level_text_size := rl.MeasureTextEx(fnt_main, _level_text, _level_text_font_size, _level_text_font_spaceing)

		rl.DrawTextEx(
			fnt_main,
			_level_text,
			{(WINDOW_SIZE.x / 2) + 2 - (_level_text_size.x / 2), top_anchor_pos_y + 2},
			_level_text_font_size,
			_level_text_font_spaceing,
			C_BLACK,
		)

		rl.DrawTextEx(
			fnt_main,
			_level_text,
			{WINDOW_SIZE.x / 2 - (_level_text_size.x / 2), top_anchor_pos_y},
			_level_text_font_size,
			_level_text_font_spaceing,
			C_LIGHT_BROWN,
		)

		// 
		_timer_text: cstring = "00:00"
		_total_deaths: cstring = rl.TextFormat("%d", kills)
		_total_xp: cstring = rl.TextFormat("%d", xp_total)

		if time_sec < 10 && time_min < 10 {
			_timer_text = rl.TextFormat("0%d:0%d", time_min, time_sec)
		} else if time_sec < 10 && time_min >= 10 {
			_timer_text = rl.TextFormat("%d:0%d", time_min, time_sec)
		} else if time_sec >= 10 && time_min < 10 {
			_timer_text = rl.TextFormat("0%d:%d", time_min, time_sec)
		} else {
			_timer_text = rl.TextFormat("%d:%d", time_min, time_sec)
		}


		rl.DrawTexturePro(tex_tileset, {496, 64, 16, 16}, {32, 32, 32, 32}, {0, 0}, 0, rl.WHITE)
		rl.DrawTextEx(fnt_main, _timer_text, {66, 38}, 24, 1.0, C_BLACK)
		rl.DrawTextEx(fnt_main, _timer_text, {64, 36}, 24, 1.0, C_YELLOW)

		// Deaths
		rl.DrawTexturePro(tex_tileset, {480, 64, 16, 16}, {32, 64, 32, 32}, {0, 0}, 0, rl.WHITE)
		rl.DrawTextEx(fnt_main, _total_deaths, {66, 70}, 24, 1.0, C_BLACK)
		rl.DrawTextEx(fnt_main, _total_deaths, {64, 68}, 24, 1.0, C_YELLOW)

		// Gold
		rl.DrawTexturePro(tex_tileset, {512, 64, 16, 16}, {32, 96, 32, 32}, {0, 0}, 0, rl.WHITE)
		rl.DrawTextEx(fnt_main, _total_xp, {66, 102}, 24, 1.0, C_BLACK)
		rl.DrawTextEx(fnt_main, _total_xp, {64, 100}, 24, 1.0, C_YELLOW)
	}

}
