package game

import rl "../../raylib"
import "core:math"
import "core:c"

MAX_ENEMIES_ON_SCREEN :: 20

EnemyType :: enum {
	SNAKE_A,
	SNAKE_B,
	MINER_A,
	MINER_B,
	CROW_A,
	CROW_B,
	CAYOTE_A,
	CAYOTE_B,
	CUBE_SMALL,
	CUBE_LARGE,
}

Enemy :: struct {
	position:   rl.Vector2,
	sprite:     AnimatedSprite,
	is_active:  bool,
	is_flipped: bool,
	move_speed: f32,
	type:       EnemyType,
	target_index: c.int,
	hp: i32,
	hp_recovery_timer: f32,
	hp_recovery_duration: f32,
	can_be_hit: bool
}

enemyMoveSpeeds: [EnemyType]rl.Vector2 = {
	.SNAKE_A    = {15, 20},
	.SNAKE_B    = {20, 25},
	.MINER_A    = {25, 30},
	.MINER_B    = {25, 30},
	.CROW_A     = {30, 35},
	.CROW_B     = {35, 40},
	.CAYOTE_A   = {40, 45},
	.CAYOTE_B   = {45, 50},
	.CUBE_SMALL = {50, 55},
	.CUBE_LARGE = {55, 60},
}

enemyHp: [EnemyType]i32 = {
	.SNAKE_A    = 1,
	.SNAKE_B    = 1,
	.MINER_A    = 2,
	.MINER_B    = 2,
	.CROW_A     = 2,
	.CROW_B     = 2,
	.CAYOTE_A   = 2,
	.CAYOTE_B   = 2,
	.CUBE_SMALL = 3,
	.CUBE_LARGE = 5,
}

enemyAnimations: [EnemyType]AnimatedSprite = {
	.SNAKE_A = {
		source_rect = {0, 96, 32, 32},
		origin = {16, 16},
		total_frames = 2,
		frame_duration = 0.1,
		state = .RUN,
		collider_rect = {16, 0, 32, 16},
	},
	.SNAKE_B = {
		source_rect = {320, 96, 32, 32},
		origin = {16, 16},
		total_frames = 2,
		frame_duration = 0.1,
		state = .RUN,
		collider_rect = {16, 0, 32, 16},
	},
	.MINER_A = {
		source_rect = {192, 96, 32, 32},
		origin = {16, 16},
		total_frames = 2,
		frame_duration = 0.2,
		state = .RUN,
		collider_rect = {6, 17, 12, 30},
	},
	.MINER_B = {
		source_rect = {512, 96, 32, 32},
		origin = {16, 16},
		total_frames = 2,
		frame_duration = 0.2,
		state = .RUN,
		collider_rect = {6, 17, 12, 30},
	},
	.CROW_A = {
		source_rect = {256, 96, 32, 32},
		origin = {16, 16},
		total_frames = 2,
		frame_duration = 0.1,
		state = .RUN,
		collider_rect = {12,12, 24, 24},
	},
	.CROW_B = {
		source_rect = {576, 96, 32, 32},
		origin = {16, 16},
		total_frames = 2,
		frame_duration = 0.1,
		state = .RUN,
		collider_rect = {12,12, 24, 24},
	},
	.CAYOTE_A = {
		source_rect = {64, 96, 32, 32},
		origin = {16, 16},
		total_frames = 4,
		frame_duration = 0.1,
		state = .RUN,
		collider_rect = {16, 0, 32, 16},
	},
	.CAYOTE_B = {
		source_rect = {384, 96, 32, 32},
		origin = {16, 16},
		total_frames = 4,
		frame_duration = 0.1,
		state = .RUN,
		collider_rect = {16, 0, 32, 16},
	},
	.CUBE_SMALL = {
		source_rect = {416, 64, 32, 32},
		origin = {16, 16},
		total_frames = 2,
		frame_duration = 0.1,
		state = .RUN,
		collider_rect = {16, 16, 32, 32},
	},
	.CUBE_LARGE = {
		source_rect = {640, 64, 64, 64},
		origin = {32, 32},
		total_frames = 2,
		frame_duration = 0.1,
		state = .RUN,
		collider_rect = {32, 32, 64, 64},
	},
}

assault_delay_timer: f32
assault_delay_duration: f32 = 3.0
start_spawning_enemies: bool = false

enemy_spawn_buffer_delay: f32 = 1.0
enemy_spawn_buffer_timer: f32

current_enemy_wave_lineup: [4]EnemyType

enemies: [MAX_ENEMIES_ON_SCREEN]Enemy

current_wave := 0
current_enemy_type:EnemyType = .SNAKE_A

enemies_create :: proc() {}
enemies_update :: proc() {
	if current_state != .GAME {
		return
	}
	if !start_spawning_enemies {
		assault_delay_timer += rl.GetFrameTime()
		if assault_delay_timer >= assault_delay_duration {
			assault_delay_timer = 0
			start_spawning_enemies = true
		}
	} else {
		enemy_spawn_buffer_timer += rl.GetFrameTime()
		if enemy_spawn_buffer_timer >= assault_delay_duration {
			enemy_spawn_buffer_timer = 0
			spawn_enemy()
		}
	}

	for &_enemy in enemies {
		if _enemy.is_active {
			_target_vec:= direction_vector_normalized(_enemy.position, players[_enemy.target_index].position)

			_enemy.position += _target_vec * _enemy.move_speed * rl.GetFrameTime()

			if _enemy.position.x > players[_enemy.target_index].position.x{
				_enemy.is_flipped = true
			}else{
				_enemy.is_flipped = false
			}
			update_animated_sprite(&_enemy.sprite)
		}
	}

}
enemies_draw :: proc() {
	if current_state == .GAME_OVER || current_state == .MAIN_MENU{
		return
	}
	for _enemy in enemies {
		if _enemy.is_active {
			draw_animated_sprite(_enemy.sprite, _enemy.position, _enemy.is_flipped, 0, rl.WHITE)
		}
	}
}
enemies_draw_gui :: proc() {}

enemies_update_wave :: proc() {
	current_wave += 1
	start_spawning_enemies = false
	if current_wave == 1{
		current_enemy_type = .SNAKE_A
	}
	if current_wave == 2{
		current_enemy_type = .SNAKE_B
	}
	if current_wave == 3{
		current_enemy_type = .MINER_A
	}
	if current_wave == 4{
		current_enemy_type = .MINER_B
	}
	if current_wave == 5{
		current_enemy_type = .CROW_A
	}
	if current_wave == 6{
		current_enemy_type = .CROW_B
	}
	if current_wave == 7{
		current_enemy_type = .CAYOTE_A
	}
	if current_wave == 8{
		current_enemy_type = .CAYOTE_B
	}
	if current_wave == 8{
		current_enemy_type = .CUBE_SMALL
	}
	if current_wave == 9{
		current_enemy_type = .CUBE_LARGE
	}
}
spawn_enemy :: proc() {
	for &_enemy in enemies {
		if !_enemy.is_active {
			_enemy_speed := enemyMoveSpeeds[current_enemy_type]

			_rand_speed := rl.GetRandomValue(i32(_enemy_speed.x), i32(_enemy_speed.y))
			_player_pos := players[0].position

			_rand_angle: f32 = f32(rl.GetRandomValue(0, 360))


			_move_speed :f32= f32(_rand_speed)

			_chance := rl.GetRandomValue(0,100)
			if _chance < perk_miner_slow_chance{
				_move_speed = f32(_rand_speed)/3
			}
			_enemy = {
				is_active  = true,
				sprite     = enemyAnimations[current_enemy_type],
				move_speed = _move_speed,
				position   = {
					_player_pos.x + math.cos_f32(_rand_angle) * WORLD_SIZE.x,
					_player_pos.y + math.sin_f32(_rand_angle) * WORLD_SIZE.x,
				},
				type       = current_enemy_type,
				target_index = rl.GetRandomValue(0,1),
				hp = enemyHp[current_enemy_type],
				hp_recovery_duration = 1.0,
				can_be_hit = true
			}
		}
	}
}
