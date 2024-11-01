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
	position:       rl.Vector2,
	current_sprite: AnimatedSprite,
	is_active:      bool,
	is_flipped:     bool,
	is_spawned:     bool,
	move_speed:     f32,
	type:           PlayerType,
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
revolver_reload_duration: f32 = 2.5
revolver_shot_timer: f32
revolver_barrel: rl.Vector2 = {0, 0}


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

	players[1].is_active = false
	players[1].is_spawned = true
	players[1].position = {((LEVEL_SIZE.x / 2) * 16) - 64, ((LEVEL_SIZE.y / 2) * 16) - 64}
	players[1].move_speed = 90
	players[1].type = .MINER
	players[1].current_sprite = anim_player_miner_idle

	for i: int = 0; i < MAX_REVOLVER_BULLETS; i += 1 {
		revolver_bullets[i] = {
			type            = .PLAYER,
			lifespan        = 2.0,
			speed           = 250,
			tex_source_rect = {384, 80, 16, 16},
			show            = false,
			show_duration   = 0.15,
		}
	}
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

		players[current_active_player_index].position +=
			player_velocity * players[current_active_player_index].move_speed * dt

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
				if revolver_shot_timer >= revolver_reload_duration {
					revolver_shot_timer = 0
					can_shoot_revolver = true
				}
			}
		}


		if players[current_active_player_index].position.x > (camera.offset.x / 2) &&
		   players[current_active_player_index].position.x < (LEVEL_SIZE.x * 16) - (camera.offset.x / 2) {
			camera.target.x = rl.Lerp(camera.target.x,players[current_active_player_index].position.x,CAMERA_LERP_SMOOTH)
		}
		if players[current_active_player_index].position.y > (camera.offset.y / 2) &&
		   players[current_active_player_index].position.y < (LEVEL_SIZE.y * 16) - (camera.offset.y / 2) {
			camera.target.y = rl.Lerp(camera.target.y,players[current_active_player_index].position.y,CAMERA_LERP_SMOOTH)
		}
		////


	}


	// Updates
	for &_player in players {
		if _player.is_spawned {
			update_animated_sprite(&_player.current_sprite)
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

obj_player_draw :: proc() {


	for i: int = 0; i < MAX_PLAYERS; i += 1 {
		if players[i].is_spawned {
			if players[i].type == .MINER{
				_axe_angle :f32= -135
				if players[i].is_flipped{
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

}

obj_player_draw_gui :: proc() {


}
