package game

import rl "../../raylib"

hud_create::proc(){
	
}
hud_update::proc(){}
hud_draw::proc(){}
hud_draw_gui::proc(){
	hud_lvl_bar_outter_buffer :i32= 256
	hud_lvl_bar_outter_width := i32(WINDOW_SIZE.x) - hud_lvl_bar_outter_buffer
	rl.DrawRectangle(
		i32(hud_lvl_bar_outter_buffer/2),
		i32(WINDOW_SIZE.y-72),
		hud_lvl_bar_outter_width,24,
		{32,32,32,255}
	)
	rl.DrawRectangle(
		i32(hud_lvl_bar_outter_buffer/2)+2,
		i32(WINDOW_SIZE.y-72)+2,
		hud_lvl_bar_outter_width-256,20,
		{246,205,38,255}
	)

	_level_text :cstring= rl.TextFormat("LEVEL %d",level)
	_level_text_font_size :f32 = 24
	_level_text_font_spaceing:f32 = 1.0
	_level_text_size := rl.MeasureTextEx(
		fnt_main,
		_level_text,
		_level_text_font_size,
		_level_text_font_spaceing
	)

	rl.DrawTextEx(
		fnt_main,
		_level_text,
		{(WINDOW_SIZE.x/2)+2-(_level_text_size.x/2),(WINDOW_SIZE.y-72)+2},
		_level_text_font_size,
		_level_text_font_spaceing,
		C_BLACK
	)

	rl.DrawTextEx(
		fnt_main,
		_level_text,
		{WINDOW_SIZE.x/2-(_level_text_size.x/2),WINDOW_SIZE.y-72},
		_level_text_font_size,
		_level_text_font_spaceing,
		C_LIGHT_BROWN
	)
}

