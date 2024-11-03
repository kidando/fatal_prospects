package game

import rl "../../raylib"

show_game_over :: proc() {
	rl.PlaySound(snd_game_over)
	current_state = .GAME_OVER
}

game_over_update :: proc() {
	if current_state == .GAME_OVER {
		if rl.IsKeyPressed(.R) {
			reset_game()

		}
	}
}

game_over_draw_gui :: proc() {
	if current_state == .GAME_OVER {
		text: cstring = "GAME OVER"
		font_size: f32 = 180
		text_size := rl.MeasureTextEx(fnt_main, text, font_size, 6.0)
		rl.DrawTextEx(fnt_main, text, {(WINDOW_SIZE.x / 2) - (text_size.x / 2), 240}, font_size, 6.0, C_BLACK)

		gold_final_text := rl.TextFormat("GOLD: %d", xp_total)
		gold_final_text_size := rl.MeasureTextEx(fnt_main, gold_final_text, 36, 3.0)

		rl.DrawTextEx(
			fnt_main,
			gold_final_text,
			{(WINDOW_SIZE.x / 2) - (gold_final_text_size.x / 2), 400},
			36,
			4.0,
			C_YELLOW,
		)


		kills_final_text := rl.TextFormat("KILLS: %d", kills)
		kills_final_text_size := rl.MeasureTextEx(fnt_main, kills_final_text, 36, 3.0)

		rl.DrawTextEx(
			fnt_main,
			kills_final_text,
			{(WINDOW_SIZE.x / 2) - (kills_final_text_size.x / 2), 400 + 32},
			36,
			4.0,
			C_YELLOW,
		)

		restart_text: cstring = "Press R To Restart"
		restart_text_size := rl.MeasureTextEx(fnt_main, restart_text, 36, 4.0)

		rl.DrawTextEx(
			fnt_main,
			restart_text,
			{(WINDOW_SIZE.x / 2) - (restart_text_size.x / 2), 400 + 80},
			36,
			4.0,
			C_BLACK,
		)
	}

}


reset_game::proc(){
	current_state = .GAME
			players[0].is_spawned = true
			players[0].is_active = true
			players[0].position = {(LEVEL_SIZE.x / 2) * 16, (LEVEL_SIZE.y / 2) * 16}
			players[0].move_speed = 90
			players[0].type = .SHOOTER
			players[0].current_sprite = anim_player_shooter_idle
			players[0].hp = 100
			players[0].hp_max = 100
			players[0].hurt_recovery_duration = 1.0
			players[0].can_get_hurt = true

			players[1].is_active = false
			players[1].is_spawned = true
			players[1].position = {((LEVEL_SIZE.x / 2) * 16) - 64, ((LEVEL_SIZE.y / 2) * 16) - 64}
			players[1].move_speed = 90
			players[1].type = .MINER
			players[1].current_sprite = anim_player_miner_idle
			players[1].mine_cooldown = 1.2
			players[1].can_mine = true
			players[1].hp = 100
			players[1].hp_max = 100
			players[1].hurt_recovery_duration = 1.0
			players[1].can_get_hurt = true

			perk_miner_movespeed = 0
			perk_shooter_movespeed = 0
			perk_shooter_damage = 0
			perk_shooter_reload_speed = 0
			perk_shooter_chance_to_drop_gold_from_shot = 0
			perk_miner_bonus_xp = 0
			perk_miner_speed = 0
			perk_miner_kill_chance = 0
			perk_miner_slow_chance = 0
			xp = 0
			xp_max = 10
			level = 0
			kills = 0
			xp_total = 0
			time_sec = 0
			time_min = 10
			time_timer = 0
			current_wave = 0
			assault_delay_timer= 0
			start_spawning_enemies = false
			enemies = {}
}