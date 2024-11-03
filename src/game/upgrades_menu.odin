package game

import rl "../../raylib"
MAX_UPGRADE_MENU_ITEMS :: 3
show_upgrades_menu: bool = false
upgrade_menu_show_position: rl.Vector2 = {128, 64}
upgrade_menu_hide_position: rl.Vector2 = {128, 128}
upgrade_menu_position: rl.Vector2
upgrade_menu_opacity: u8 = 0
upgrade_menu_tween_speed: f32 = 0.07
upgrade_menu_width: i32 = i32(WINDOW_SIZE.x) - 256
upgrade_menu_height: i32 = i32(WINDOW_SIZE.y) - 128

upgrade_menu_item_width: i32 = 290
upgrade_menu_item_height: i32 = 424

upgrade_menu_item_gap: f32 = 0
upgrade_menu_item_icon_size: rl.Vector2 = {128, 128}
upgrade_menu_item_icon_offset_x: f32
upgrade_menu_item_icon_offset_y: f32 = 32

upgrade_menu_selected_item_index:i32 = 0
can_select_upgrade:bool = false
rand_upgrade_item_selection:[3]i32


upgrades_menu_create :: proc() {
	upgrade_menu_position = upgrade_menu_hide_position
	_remainder_space := upgrade_menu_width - (upgrade_menu_item_width * MAX_UPGRADE_MENU_ITEMS)
	upgrade_menu_item_gap = f32(_remainder_space) / f32(MAX_UPGRADE_MENU_ITEMS + 1)

	upgrade_menu_item_icon_offset_x = (f32(upgrade_menu_item_width) - upgrade_menu_item_icon_size.x) / 2.0
}
upgrades_menu_update :: proc() {
	if show_upgrades_menu {
		upgrade_menu_opacity = u8(rl.Lerp(f32(upgrade_menu_opacity), 255, upgrade_menu_tween_speed))
		upgrade_menu_position.y = rl.Lerp(
			upgrade_menu_position.y,
			upgrade_menu_show_position.y,
			upgrade_menu_tween_speed,
		)
	}else{
		upgrade_menu_opacity = u8(rl.Lerp(f32(upgrade_menu_opacity), 0, upgrade_menu_tween_speed))
		upgrade_menu_position.y = rl.Lerp(
			upgrade_menu_position.y,
			upgrade_menu_hide_position.y,
			upgrade_menu_tween_speed,
		)
	}

	if DEBUG_MODE && rl.IsKeyPressed(.U) && current_state == .GAME{
		upgrades_menu_launch_menu(true)
	}

	if current_state == .UPGRADES_MENU{
		if can_select_upgrade && rl.IsMouseButtonPressed(.LEFT){
			upgrades_menu_launch_menu(false)
		}
	}

	
}
upgrades_menu_draw :: proc() {}

upgrades_menu_draw_gui :: proc() {

	text_size := rl.MeasureTextEx(fnt_main, "Select an Upgrade", 48, 4.0)
	_color: rl.Color = {C_YELLOW.r, C_YELLOW.g, C_YELLOW.b, upgrade_menu_opacity}
	rl.DrawRectangle(
		i32(upgrade_menu_position.x),
		i32(upgrade_menu_position.y),
		upgrade_menu_width,
		upgrade_menu_height,
		{C_BLACK.r, C_BLACK.g, C_BLACK.b, upgrade_menu_opacity},
	)
	// HEADER
	rl.DrawTextEx(
		fnt_main,
		"Select an Upgrade",
		{(WINDOW_SIZE.x / 2) - text_size.x / 2, upgrade_menu_position.y + 36},
		48,
		4.0,
		upgrade_menu_opacity,
	)


	can_select_upgrade = false
	for i: i32 = 0; i < MAX_UPGRADE_MENU_ITEMS; i += 1 {
		_upgrade := upgrades[rand_upgrade_item_selection[i]]
		_item_rect_x :=
			i32(upgrade_menu_position.x + upgrade_menu_item_gap) +
			(i * (upgrade_menu_item_width + i32(upgrade_menu_item_gap)))
		_item_rect_y := i32(upgrade_menu_position.y) + 110
		_item_rect_width := upgrade_menu_item_width
		_item_rect_height := upgrade_menu_item_height

		_mouse_position := rl.GetMousePosition()

		if _mouse_position.x > f32(_item_rect_x) &&
		   _mouse_position.x < f32(_item_rect_x + _item_rect_width) &&
		   _mouse_position.y > f32(_item_rect_y) &&
		   _mouse_position.y < f32(_item_rect_y + _item_rect_height) {
			rl.DrawRectangle(
				_item_rect_x, 
				_item_rect_y, 
				_item_rect_width, 
				_item_rect_height, 
				{
					C_DARK_GREY.r,
					C_DARK_GREY.g,
					C_DARK_GREY.b,
					upgrade_menu_opacity
				}
			)
			upgrade_menu_selected_item_index = rand_upgrade_item_selection[i]
			can_select_upgrade = true
		}

		rl.DrawRectangleLines(
			_item_rect_x,
			_item_rect_y,
			_item_rect_width,
			_item_rect_height,
			{
				C_YELLOW.r,
				 C_YELLOW.g, 
				 C_YELLOW.b, 
				 upgrade_menu_opacity
				},
		)

		rl.DrawTexturePro(
			tex_tileset,
			{528, 64, 32, 32},
			{
				f32(_item_rect_x) + upgrade_menu_item_icon_offset_x,
				f32(_item_rect_y) + upgrade_menu_item_icon_offset_y,
				upgrade_menu_item_icon_size.x,
				upgrade_menu_item_icon_size.y,
			},
			{0, 0},
			0,
			{
				rl.WHITE.r,
				rl.WHITE.g,
				rl.WHITE.b,
				upgrade_menu_opacity
			},
		)

		

		_upgrade_font_size: f32 = 24.0
		_upgrade_font_spacing: f32 = 2.0
		_upgrade_name: cstring = _upgrade.name
		_upgrade_measure := rl.MeasureTextEx(fnt_main, _upgrade_name, 24, 2.0)
		_upgrade_name_gap := (f32(_item_rect_width) - _upgrade_measure.x) / 2

		_upgrade_desc_line1: cstring = rl.TextFormat("Affects: %s",upgradeTypeName[_upgrade.type])
		_upgrade_desc_line2: cstring = _upgrade.desc1
		_upgrade_desc_line3: cstring = _upgrade.desc2
		_upgrade_desc_line4: cstring = _upgrade.desc3
		_upgrade_desc_line5: cstring = _upgrade.desc4

		rl.DrawTextEx(
			fnt_main,
			_upgrade_name,
			{f32(_item_rect_x) + _upgrade_name_gap, f32(_item_rect_y) + 180},
			_upgrade_font_size,
			_upgrade_font_spacing,
			{
				C_YELLOW.r,
				C_YELLOW.g,
				C_YELLOW.b,
				upgrade_menu_opacity
			},
		)

		rl.DrawTextEx(
			fnt_main,
			_upgrade_desc_line1,
			{f32(_item_rect_x) + 16, f32(_item_rect_y) + 236},
			_upgrade_font_size,
			_upgrade_font_spacing,
			{
				C_YELLOW.r,
				C_YELLOW.g,
				C_YELLOW.b,
				upgrade_menu_opacity
			},
		)

		rl.DrawTextEx(
			fnt_main,
			_upgrade_desc_line2,
			{f32(_item_rect_x) + 16, f32(_item_rect_y) + 236 + 32},
			_upgrade_font_size,
			_upgrade_font_spacing,
			{
				C_LIGHT_BROWN.r,
				C_LIGHT_BROWN.g,
				C_LIGHT_BROWN.b,
				upgrade_menu_opacity
			},
		)
		rl.DrawTextEx(
			fnt_main,
			_upgrade_desc_line3,
			{f32(_item_rect_x) + 16, f32(_item_rect_y) + 236 + 64},
			_upgrade_font_size,
			_upgrade_font_spacing,
			{
				C_LIGHT_BROWN.r,
				C_LIGHT_BROWN.g,
				C_LIGHT_BROWN.b,
				upgrade_menu_opacity
			},
		)
		rl.DrawTextEx(
			fnt_main,
			_upgrade_desc_line4,
			{f32(_item_rect_x) + 16, f32(_item_rect_y) + 236 + 96},
			_upgrade_font_size,
			_upgrade_font_spacing,
			{
				C_LIGHT_BROWN.r,
				C_LIGHT_BROWN.g,
				C_LIGHT_BROWN.b,
				upgrade_menu_opacity
			},
		)
		rl.DrawTextEx(
			fnt_main,
			_upgrade_desc_line5,
			{f32(_item_rect_x) + 16, f32(_item_rect_y) + 236 + 128},
			_upgrade_font_size,
			_upgrade_font_spacing,
			{
				C_LIGHT_BROWN.r,
				C_LIGHT_BROWN.g,
				C_LIGHT_BROWN.b,
				upgrade_menu_opacity
			},
		)


	}
}


upgrades_menu_launch_menu :: proc(_show:bool) {
	if _show{
		rl.PlaySound(snd_level_up)
		show_upgrades_menu = true
		current_state = .UPGRADES_MENU
		rand_upgrade_item_selection[0] = rl.GetRandomValue(0,MAX_UPGRADES-1)
		rand_upgrade_item_selection[1] = rl.GetRandomValue(0,MAX_UPGRADES-1)
		rand_upgrade_item_selection[2] = rl.GetRandomValue(0,MAX_UPGRADES-1)
		
	}else{
		show_upgrades_menu = false
		current_state = .GAME
		activate_upgrade(upgrade_menu_selected_item_index)
		rl.PlaySound(snd_upgrade_selected)

		if xp_balance > 0{
			gain_xp(xp_balance)
		}
	}
	
}
