package game

import rl "../../raylib"
import "core:math"

// ENUMS
PlayerType :: enum {
	SHOOTER,
	MINER,
}

// STRUCTS
Player :: struct {
	position:               rl.Vector2,
	current_sprite:         AnimatedSprite,
	is_active:              bool,
	is_flipped:             bool,
	is_spawned:             bool,
	move_speed:             f32,
	type:                   PlayerType,
	can_mine:               bool,
	mine_timer:             f32,
	mine_cooldown:          f32,
	hp:                     f32,
	hp_max:                 f32,
	can_get_hurt:           bool,
	hurt_recovery_timer:    f32,
	hurt_recovery_duration: f32,
}

// CONSTANTS
MAX_PLAYERS :: 10
MAX_REVOLVER_BULLETS :: 30
players: [MAX_PLAYERS]Player
revolver_bullets: [MAX_REVOLVER_BULLETS]Projectile


// VARIABLES
player_common_collider_rect: rl.Rectangle = {6, 17, 12, 30}
player_common_origin: rl.Vector2 = {16, 19}

anim_player_shooter_idle := AnimatedSprite {
	source_rect    = {0, 0, 32, 32},
	origin         = {16, 16},
	total_frames   = 4,
	frame_duration = 0.08,
	collider_rect  = {6, 17, 12, 30},
	state          = .IDLE,
}
anim_player_shooter_run := AnimatedSprite {
	source_rect    = {128, 0, 32, 32},
	origin         = {16, 16},
	total_frames   = 8,
	frame_duration = 0.07,
	collider_rect  = {6, 30, 12, 30},
	state          = .RUN,
}
anim_player_shooter_die := AnimatedSprite {
	source_rect    = {384, 0, 32, 32},
	origin         = {16, 16},
	total_frames   = 12,
	frame_duration = 0.1,
	collider_rect  = {6, 30, 12, 30},
	state          = .DIE,
}

anim_player_miner_idle := AnimatedSprite {
	source_rect    = {0, 32, 32, 32},
	origin         = {16, 16},
	total_frames   = 4,
	frame_duration = 0.08,
	collider_rect  = {6, 30, 12, 30},
	state          = .IDLE,
}
anim_player_miner_run := AnimatedSprite {
	source_rect    = {128, 32, 32, 32},
	origin         = {16, 16},
	total_frames   = 8,
	frame_duration = 0.07,
	collider_rect  = {6, 30, 12, 30},
	state          = .RUN,
}
anim_player_miner_die := AnimatedSprite {
	source_rect    = {384, 32, 32, 32},
	origin         = {16, 16},
	total_frames   = 12,
	frame_duration = 0.1,
	collider_rect  = {6, 30, 12, 30},
	state          = .DIE,
}

anim_player_current: AnimatedSprite
current_active_player_index: int = 0
max_available_players: int = 2
is_player_dead: bool = false


can_shoot_revolver: bool = false
revolver_reload_duration: f32 = 1.5
revolver_shot_timer: f32
revolver_barrel: rl.Vector2 = {0, 0}


perk_miner_movespeed: f32 = 0
perk_shooter_movespeed: f32 = 0
perk_shooter_damage: i32 = 0
perk_shooter_reload_speed: f32 = 0
perk_shooter_chance_to_drop_gold_from_shot: i32 = 0
perk_miner_bonus_xp: i32 = 0
perk_miner_speed: f32 = 0
perk_miner_kill_chance: i32
perk_miner_slow_chance: i32


// FUNCTIONS
obj_player_create :: proc() {

	anim_player_shooter_idle.origin = player_common_origin
	anim_player_shooter_run.origin = player_common_origin
	anim_player_shooter_die.origin = player_common_origin
	anim_player_miner_idle.origin = player_common_origin
	anim_player_miner_run.origin = player_common_origin
	anim_player_miner_die.origin = player_common_origin

	anim_player_shooter_idle.collider_rect = player_common_collider_rect
	anim_player_shooter_run.collider_rect = player_common_collider_rect
	anim_player_shooter_die.collider_rect = player_common_collider_rect
	anim_player_miner_idle.collider_rect = player_common_collider_rect
	anim_player_miner_run.collider_rect = player_common_collider_rect
	anim_player_miner_die.collider_rect = player_common_collider_rect

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


	for i: int = 0; i < MAX_REVOLVER_BULLETS; i += 1 {
		revolver_bullets[i] = {
			type            = .PLAYER,
			lifespan        = 2.0,
			speed           = 250,
			tex_source_rect = {384, 80, 16, 16},
			show            = false,
			show_duration   = 0.15,
			damage          = 1,
		}
	}
	camera.target = {((LEVEL_SIZE.x / 2) * 16) - 64, ((LEVEL_SIZE.y / 2) * 16) - 64}
}

obj_player_update :: proc() {

	dt := rl.GetFrameTime()


	// Inputs
	if !is_player_dead && current_state == .GAME {


		if rl.IsMouseButtonPressed(.LEFT) {
			if players[current_active_player_index].current_sprite.state != .IDLE {
				if players[current_active_player_index].type == .SHOOTER {
					players[current_active_player_index].current_sprite = anim_player_shooter_idle
				} else {
					players[current_active_player_index].current_sprite = anim_player_miner_idle
				}
			}
			current_active_player_index += 1
			if current_active_player_index > max_available_players - 1 {
				current_active_player_index = 0
			}

		}
		if rl.IsMouseButtonPressed(.RIGHT) {
			if players[current_active_player_index].current_sprite.state != .IDLE {
				if players[current_active_player_index].type == .SHOOTER {
					players[current_active_player_index].current_sprite = anim_player_shooter_idle
				} else {
					players[current_active_player_index].current_sprite = anim_player_miner_idle
				}
			}
			current_active_player_index -= 1
			if current_active_player_index < 0 {
				current_active_player_index = max_available_players - 1
			}
		}

		////
		player_velocity: rl.Vector2
		if rl.IsKeyDown(.A) && players[current_active_player_index].position.x > LEVEL_LIMIT_BUFFER {
			player_velocity.x = -1
		} else if rl.IsKeyDown(.D) &&
		   players[current_active_player_index].position.x < (LEVEL_SIZE.x * 16) - LEVEL_LIMIT_BUFFER {
			player_velocity.x = 1
		}
		if rl.IsKeyDown(.W) && players[current_active_player_index].position.y > LEVEL_LIMIT_BUFFER {
			player_velocity.y = -1
		} else if rl.IsKeyDown(.S) &&
		   players[current_active_player_index].position.y < (LEVEL_SIZE.y * 16) - LEVEL_LIMIT_BUFFER {
			player_velocity.y = 1
		}

		player_velocity = rl.Vector2Normalize(player_velocity)

		if rl.Vector2Length(player_velocity) != 0 {
			if players[current_active_player_index].current_sprite.state != .RUN {
				if players[current_active_player_index].type == .SHOOTER {
					players[current_active_player_index].current_sprite = anim_player_shooter_run
				} else {
					players[current_active_player_index].current_sprite = anim_player_miner_run
				}
			}
		} else {
			if players[current_active_player_index].current_sprite.state != .IDLE {
				if players[current_active_player_index].type == .SHOOTER {
					players[current_active_player_index].current_sprite = anim_player_shooter_idle
				} else {
					players[current_active_player_index].current_sprite = anim_player_miner_idle
				}
			}
		}

		_additional_speed: f32
		if players[current_active_player_index].type == .MINER {
			_additional_speed = perk_miner_movespeed
		} else {
			_additional_speed = perk_shooter_movespeed
		}

		players[current_active_player_index].position +=
			player_velocity * (players[current_active_player_index].move_speed + _additional_speed) * dt

		// Weapons
		if players[current_active_player_index].type == .SHOOTER {
			if can_shoot_revolver {
				can_shoot_revolver = false
				rl.PlaySound(snd_revolver)
				for &_bullet in revolver_bullets {
					if !_bullet.is_active {
						_bullet.is_active = true
						_bullet.show = false
						_bullet.rotation = angle_between_vectors(
							players[current_active_player_index].position,
							mouse_position,
						)
						_bullet.position.x =
							players[current_active_player_index].position.x +
							lengthdir_x(revolver_barrel.x, _bullet.rotation)
						_bullet.position.y =
							players[current_active_player_index].position.y +
							lengthdir_y(revolver_barrel.y, _bullet.rotation)
						_bullet.direction = direction_vector_normalized(_bullet.position, mouse_position)
						break
					}
				}

			} else {
				revolver_shot_timer += rl.GetFrameTime()
				if revolver_shot_timer >= revolver_reload_duration - perk_shooter_reload_speed {
					revolver_shot_timer = 0
					can_shoot_revolver = true
				}
			}
		}

		if players[1].type == .MINER {
			// Check for collisions
			for &_deposit in gold_deposits {
				if _deposit.is_active {
					_miner := players[1]
					_miner_rect: rl.Rectangle = {
						_miner.position.x - _miner.current_sprite.collider_rect.x,
						_miner.position.y - _miner.current_sprite.collider_rect.y,
						_miner.current_sprite.collider_rect.width,
						_miner.current_sprite.collider_rect.height,
					}

					_source_rect := goldDepositSourceRects[_deposit.type]

					_deposit_rect: rl.Rectangle = {
						_deposit.position.x,
						_deposit.position.y,
						_source_rect.width,
						_source_rect.height,
					}
					if rl.CheckCollisionRecs(_miner_rect, _deposit_rect) {

						if _deposit.can_be_mined {
							_deposit.strikes += 1
							rl.PlaySound(snd_mine)
							_deposit.can_be_mined = false
							_deposit.display_xp = true
							_deposit.display_xp_timer = 0
							_deposit.display_xp_position_shifter = 0

							_chance := rl.GetRandomValue(0, 100)
							if _chance < perk_miner_kill_chance {
								for &_enemy in enemies {
									if _enemy.is_active {
										_enemy.is_active = false
										rl.PlaySound(snd_strike_bell)
										kills += 1
										break
									}
								}
							}

							gain_xp(goldDepositValue[_deposit.type] + perk_miner_bonus_xp)
							if _deposit.strikes >= goldDepositStrikes[_deposit.type] {
								_deposit.is_active = false
								create_new_deposit()
								rl.PlaySound(snd_rock_break)
							}

						} else {
							_deposit.mine_timer += rl.GetFrameTime()
							if _deposit.mine_timer >= _deposit.mine_cooldown - perk_miner_speed {
								_deposit.mine_timer = 0
								_deposit.can_be_mined = true
							}
						}

					}

					if _deposit.display_xp {
						_deposit.display_xp_timer += rl.GetFrameTime()
						_deposit.display_xp_position_shifter -= rl.GetFrameTime() * 10
						if _deposit.display_xp_timer >= _deposit.diplay_xp_duration {
							_deposit.display_xp_timer = 0
							_deposit.display_xp = false
						}
					}
				}
			}
		}


		if players[current_active_player_index].position.x > (camera.offset.x / 2) &&
		   players[current_active_player_index].position.x < (LEVEL_SIZE.x * 16) - (camera.offset.x / 2) {
			camera.target.x = rl.Lerp(
				camera.target.x,
				players[current_active_player_index].position.x,
				CAMERA_LERP_SMOOTH,
			)
		}
		if players[current_active_player_index].position.y > (camera.offset.y / 2) &&
		   players[current_active_player_index].position.y < (LEVEL_SIZE.y * 16) - (camera.offset.y / 2) {
			camera.target.y = rl.Lerp(
				camera.target.y,
				players[current_active_player_index].position.y,
				CAMERA_LERP_SMOOTH,
			)
		}
		////


		// Updates
		for &_player in players {
			if _player.is_spawned {
				update_animated_sprite(&_player.current_sprite)

				// Check Collisons with enemies
				for _enemy in enemies {
					if _enemy.is_active {
						_enemy_collision_rect: rl.Rectangle = {
							_enemy.position.x - _enemy.sprite.collider_rect.x,
							_enemy.position.y - _enemy.sprite.collider_rect.y,
							_enemy.sprite.collider_rect.width,
							_enemy.sprite.collider_rect.height,
						}

						_player_rect: rl.Rectangle = {
							_player.position.x - _player.current_sprite.collider_rect.x,
							_player.position.y - _player.current_sprite.collider_rect.y,
							_player.current_sprite.collider_rect.width,
							_player.current_sprite.collider_rect.height,
						}

						if rl.CheckCollisionRecs(_player_rect, _enemy_collision_rect) {
							if _player.can_get_hurt {
								_player.can_get_hurt = false
								_player.hp -= 10.0
								if _player.hp <= 0 {
									show_game_over()
								} else {
									rl.PlaySound(snd_player_hurt)
								}
							}

						}
					}
				}

				if !_player.can_get_hurt {
					_player.hurt_recovery_timer += rl.GetFrameTime()
					if _player.hurt_recovery_timer >= _player.hurt_recovery_duration {
						_player.hurt_recovery_timer = 0
						_player.can_get_hurt = true
					}
				}
			}
		}

		for &_bullet in revolver_bullets {
			if _bullet.is_active {
				_bullet.position += _bullet.direction * _bullet.speed * dt

				_bullet.lifespan_timer += rl.GetFrameTime()
				if _bullet.lifespan_timer >= _bullet.lifespan {
					_bullet.lifespan_timer = 0
					_bullet.is_active = false
				}

				for &_enemy in enemies {
					if _enemy.is_active {
						_enemy_collision_rect: rl.Rectangle = {
							_enemy.position.x - _enemy.sprite.collider_rect.x,
							_enemy.position.y - _enemy.sprite.collider_rect.y,
							_enemy.sprite.collider_rect.width,
							_enemy.sprite.collider_rect.height,
						}

						_bullet_rect: rl.Rectangle = {
							_bullet.position.x - 8,
							_bullet.position.y - 8,
							_bullet.tex_source_rect.width,
							_bullet.tex_source_rect.height,
						}

						if rl.CheckCollisionRecs(_bullet_rect, _enemy_collision_rect) && _enemy.can_be_hit {
							_bullet.is_active = false
							_enemy.can_be_hit = false
							_enemy.hp -= 1 + perk_shooter_damage
							rl.PlaySound(snd_ouch)
							if _enemy.hp <= 0 {
								_enemy.is_active = false
								kills += 1
								_chance := rl.GetRandomValue(0, 100)
								if _chance < perk_shooter_chance_to_drop_gold_from_shot {
									rl.PlaySound(snd_mine)
									gain_xp(1)
								}
							}
						}
					}
					if !_enemy.can_be_hit {
						_enemy.hp_recovery_timer += rl.GetFrameTime()
						if _enemy.hp_recovery_timer >= _enemy.hp_recovery_duration {
							_enemy.can_be_hit = true
							_enemy.hp_recovery_timer = 0
						}
					}
				}


			}
			if !_bullet.show {
				_bullet.show_timer += rl.GetFrameTime()
				if _bullet.show_timer >= _bullet.show_duration {
					_bullet.show_timer = 0
					_bullet.show = true
				}
			}
		}
	}


}

obj_player_draw :: proc() {

	if current_state == .GAME {
		for i: int = 0; i < MAX_PLAYERS; i += 1 {
			if players[i].is_spawned {

				rl.DrawRectangle(i32(players[i].position.x) - 25, i32(players[i].position.y) - 36, 50, 4, C_BLACK)
				rl.DrawRectangle(
					i32(players[i].position.x) - 24,
					i32(players[i].position.y) - 35,
					i32(48 * (players[i].hp / players[i].hp_max)),
					2,
					C_YELLOW,
				)

				if players[i].type == .MINER {
					_axe_angle: f32 = -135
					if players[i].is_flipped {
						_axe_angle = -45
					}
					// Pickaxe
					rl.DrawTexturePro(
						tex_tileset,
						{352, 80, 32, 16},
						{players[i].position.x, players[i].position.y, 32, 16},
						{0, 8},
						_axe_angle,
						rl.WHITE,
					)
				}
				draw_animated_sprite(players[i].current_sprite, players[i].position, players[i].is_flipped)
				if DEBUG_MODE && debug_show_colliders && players[i].is_active {
					rl.DrawPixel(i32(players[i].position.x), i32(players[i].position.y), rl.BLUE)
				}

				if players[i].type == .SHOOTER {

					_flip_factor: f32 = 1
					if players[i].is_flipped {
						_flip_factor = -1
					}

					_rotation: f32 = 0
					if current_active_player_index == i {

						_rotation = angle_between_vectors(players[i].position, mouse_position)
					}

					// Revolver
					rl.DrawTexturePro(
						tex_tileset,
						{256, 80, 32, 16 * _flip_factor},
						{players[i].position.x, players[i].position.y, 32, 16},
						{-4, 8},
						_rotation,
						rl.WHITE,
					)


				}
			}
		}

		for _bullet in revolver_bullets {
			if _bullet.is_active && _bullet.show {
				rl.DrawTexturePro(
					tex_tileset,
					_bullet.tex_source_rect,
					{_bullet.position.x, _bullet.position.y, 16, 16},
					{8, 8},
					_bullet.rotation,
					rl.WHITE,
				)
			}
		}

		for &_deposit in gold_deposits {
			if _deposit.is_active && _deposit.display_xp {
				_text: cstring = rl.TextFormat("+%d", goldDepositValue[_deposit.type] + perk_miner_bonus_xp)
				rl.DrawTextEx(
					fnt_main,
					_text,
					{_deposit.position.x + 1, _deposit.position.y - 31 + _deposit.display_xp_position_shifter},
					12,
					1.0,
					C_BLACK,
				)
				rl.DrawTextEx(
					fnt_main,
					_text,
					{_deposit.position.x, _deposit.position.y - 32 + _deposit.display_xp_position_shifter},
					12,
					1.0,
					C_YELLOW,
				)
			}
		}
	}


}

obj_player_draw_gui :: proc() {


}

gain_xp :: proc(_xp: i32) {
	// Check to see if xp gained is less than xp max

	xp += _xp
	xp_total += _xp
	if xp >= xp_max {
		xp_balance = xp - xp_max
		level += 1
		xp = 0
		xp_max = xp_max_base * (level + 1)
		upgrades_menu_launch_menu(true)
	}

}
