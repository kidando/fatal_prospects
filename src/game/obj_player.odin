package game

import rl "../../raylib"

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
	is_flipped:bool,
	is_spawned:     bool,
	move_speed:     f32,
	type:           PlayerType,
}

// CONSTANTS
MAX_PLAYERS :: 10
players: [MAX_PLAYERS]Player


// VARIABLES
anim_player_shooter_idle := AnimatedSprite {
	source_rect    = {0, 0, 32, 32},
	origin         = {16, 32},
	total_frames   = 4,
	frame_duration = 0.08,
	collider_rect  = {6, 30, 12, 30},
	state          = .IDLE,
}
anim_player_shooter_run := AnimatedSprite {
	source_rect    = {128, 0, 32, 32},
	origin         = {16, 32},
	total_frames   = 8,
	frame_duration = 0.07,
	collider_rect  = {6, 30, 12, 30},
	state          = .RUN,
}
anim_player_shooter_die := AnimatedSprite {
	source_rect    = {384, 0, 32, 32},
	origin         = {16, 32},
	total_frames   = 12,
	frame_duration = 0.1,
	collider_rect  = {6, 30, 12, 30},
	state          = .DIE,
}

anim_player_miner_idle := AnimatedSprite {
	source_rect    = {0, 32, 32, 32},
	origin         = {16, 32},
	total_frames   = 4,
	frame_duration = 0.08,
	collider_rect  = {6, 30, 12, 30},
	state          = .IDLE,
}
anim_player_miner_run := AnimatedSprite {
	source_rect    = {128, 32, 32, 32},
	origin         = {16, 32},
	total_frames   = 8,
	frame_duration = 0.07,
	collider_rect  = {6, 30, 12, 30},
	state          = .RUN,
}
anim_player_miner_die := AnimatedSprite {
	source_rect    = {384, 32, 32, 32},
	origin         = {16, 32},
	total_frames   = 12,
	frame_duration = 0.1,
	collider_rect  = {6, 30, 12, 30},
	state          = .DIE,
}

anim_player_current: AnimatedSprite
current_active_player_index: int = 0
is_player_dead: bool = false


// FUNCTIONS
obj_player_create :: proc() {
	players = {}
	//anim_player_current = anim_player_miner_die
	players[current_active_player_index].is_active = true
	players[current_active_player_index].is_spawned = true
	players[current_active_player_index].move_speed = 100
	players[current_active_player_index].type = .SHOOTER
	players[current_active_player_index].current_sprite = anim_player_shooter_idle
}

obj_player_update :: proc() {

	dt := rl.GetFrameTime()

	// Inputs
	if !is_player_dead {
		for &_player in players {
			if _player.is_active {
				player_velocity : rl.Vector2
				if rl.IsKeyDown(.A) {
					player_velocity.x = -1
					_player.is_flipped = true
				}else if rl.IsKeyDown(.D) {
					player_velocity.x = 1
					_player.is_flipped = false
				}
				if rl.IsKeyDown(.W) {
					player_velocity.y = -1
				}else if rl.IsKeyDown(.S) {
					player_velocity.y = 1
				}

				player_velocity = rl.Vector2Normalize(player_velocity)

				if rl.Vector2Length(player_velocity) != 0{
					if _player.current_sprite.state != .RUN {
						if _player.type == .SHOOTER{
							_player.current_sprite = anim_player_shooter_run
						}else{
							_player.current_sprite = anim_player_miner_run
						}
					}
				}else{
					if _player.current_sprite.state != .IDLE{
						if _player.type == .SHOOTER{
							_player.current_sprite = anim_player_shooter_idle
						}else{
							_player.current_sprite = anim_player_miner_idle
						}
					}
				}

				_player.position += player_velocity * _player.move_speed * dt
				camera.target = _player.position

			}
		}
	}


	// Updates
	for &_player in players {
		if _player.is_spawned && _player.is_active {
			update_animated_sprite(&_player.current_sprite)
		}
	}

}

obj_player_draw :: proc() {
	for _player in players {
		if _player.is_spawned {
			draw_animated_sprite(_player.current_sprite, _player.position, _player.is_flipped)
			if DEBUG_MODE && debug_show_colliders && _player.is_active{
				rl.DrawPixel(i32(_player.position.x), i32(_player.position.y), rl.BLUE)
			}
		}
	}

}

obj_player_draw_gui :: proc() {

}
