package game

import rl "../../raylib"


main_menu_create :: proc() {}
main_menu_update :: proc() {
	if current_state == .MAIN_MENU{
		if rl.IsKeyPressed(.SPACE){
			reset_game()
		}
	}
}
main_menu_draw :: proc() {}
main_menu_draw_gui :: proc() {

	if current_state == .MAIN_MENU {
		title_text: cstring = "FATAL PROSPECTS"
		tt_font_size: f32 = 100
		tt_font_spacing: f32 = 3.0

		tt_font_measure := rl.MeasureTextEx(fnt_main, title_text, tt_font_size, tt_font_spacing)

		rl.DrawTextEx(
			fnt_main,
			title_text,
			{(WINDOW_SIZE.x / 2) - (tt_font_measure.x / 2)+f32(rl.GetRandomValue(-4,4)), 170+f32(rl.GetRandomValue(-4,4))},
			tt_font_size,
			tt_font_spacing,
			C_YELLOW,
		)
		rl.DrawTextEx(
			fnt_main,
			title_text,
			{(WINDOW_SIZE.x / 2) - (tt_font_measure.x / 2), 170},
			tt_font_size,
			tt_font_spacing,
			C_BLACK,
		)

		regular_font_size:f32 = 24
		regular_font_spacing:f32 = 2.0

		author_text:cstring = "By Leon O. Kidando"
		author_text_measure:= rl.MeasureTextEx(
			fnt_main,
			author_text,
			regular_font_size,
			regular_font_spacing
		)

		rl.DrawTextEx(
			fnt_main,
			author_text,
			{(WINDOW_SIZE.x / 2) - (author_text_measure.x / 2), 256},
			regular_font_size,
			regular_font_spacing,
			C_BLACK,
		)

		instructions_text:cstring = "HOW TO PLAY"
		instructions_text_measure:= rl.MeasureTextEx(
			fnt_main,
			author_text,
			regular_font_size,
			regular_font_spacing
		)

		rl.DrawTextEx(
			fnt_main,
			instructions_text,
			{(WINDOW_SIZE.x / 2) - (instructions_text_measure.x / 2), 360},
			regular_font_size,
			regular_font_spacing,
			C_BLACK,
		)


		controls_text1:cstring = "1) Switch between MINER and SHOOTER by clicking on LEFT MOUSE BUTTON"
		controls_text1_measure:= rl.MeasureTextEx(
			fnt_main,
			controls_text1,
			regular_font_size,
			regular_font_spacing
		)

		rl.DrawTextEx(
			fnt_main,
			controls_text1,
			{(WINDOW_SIZE.x / 2) - (controls_text1_measure.x / 2), 360+32},
			regular_font_size,
			regular_font_spacing,
			C_BLACK,
		)


		controls_text2:cstring = "2) Move ACTIVE actor using WASD"
		controls_text2_measure:= rl.MeasureTextEx(
			fnt_main,
			controls_text2,
			regular_font_size,
			regular_font_spacing
		)

		rl.DrawTextEx(
			fnt_main,
			controls_text2,
			{(WINDOW_SIZE.x / 2) - (controls_text2_measure.x / 2), 360+64},
			regular_font_size,
			regular_font_spacing,
			C_BLACK,
		)

		controls_text3:cstring = "3) As SHOOTER, use MOUSE AIM to auto-shoot at enemies"
		controls_text3_measure:= rl.MeasureTextEx(
			fnt_main,
			controls_text3,
			regular_font_size,
			regular_font_spacing
		)

		rl.DrawTextEx(
			fnt_main,
			controls_text3,
			{(WINDOW_SIZE.x / 2) - (controls_text3_measure.x / 2), 360+96+32},
			regular_font_size,
			regular_font_spacing,
			C_BLACK,
		)


		controls_text4:cstring = "4) As MINER, walk over to gold deposits and auto-mine"
		controls_text4_measure:= rl.MeasureTextEx(
			fnt_main,
			controls_text4,
			regular_font_size,
			regular_font_spacing
		)

		rl.DrawTextEx(
			fnt_main,
			controls_text4,
			{(WINDOW_SIZE.x / 2) - (controls_text4_measure.x / 2), 360+96+64},
			regular_font_size,
			regular_font_spacing,
			C_BLACK,
		)

		controls_text5:cstring = "5) Hit SPACE to start the game"
		controls_text5_measure:= rl.MeasureTextEx(
			fnt_main,
			controls_text5,
			regular_font_size,
			regular_font_spacing
		)

		rl.DrawTextEx(
			fnt_main,
			controls_text5,
			{(WINDOW_SIZE.x / 2) - (controls_text5_measure.x / 2), 360+96+64+32},
			regular_font_size,
			regular_font_spacing,
			C_BLACK,
		)
	}
}
