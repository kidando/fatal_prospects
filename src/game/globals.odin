package game

import rl "../../raylib"


// ENUMS
GamePlayState::enum{
	MAIN_MENU,
	GAME,
	PAUSE,
	UPGRADES_MENU,
	GAME_OVER
}
AnimationState::enum{
	IDLE,
	RUN,
	DIE
}
ProjectileType::enum{
	PLAYER,
	ENEMY
}


// STRUCTS
AnimatedSprite::struct{
	source_rect:rl.Rectangle,
	origin:rl.Vector2, // Sprite origin
	total_frames: int,
	frame_duration: f32,
	current_frame:int,
	frame_timer: f32,
	state: AnimationState,
	collider_rect: rl.Rectangle // x and y => offset, width and height => size
}

Projectile::struct{
	position:rl.Vector2,
	speed:f32,
	rotation:f32,
	direction:rl.Vector2,
	damage:i32,
	tex_source_rect:rl.Rectangle,
	collision_rect:rl.Rectangle,
	type:ProjectileType,
	is_active:bool,
	show:bool,
	show_timer:f32,
	show_duration:f32,
	lifespan:f32,
	lifespan_timer:f32
}





// CONSTANTS
WINDOW_SIZE:rl.Vector2:{1280, 720}
WORLD_SIZE:rl.Vector2:{640,360}

C_YELLOW:rl.Color:{246, 205, 38, 255}
C_BLACK:rl.Color:{13, 23, 32, 255}
C_DARK_BROWN:rl.Color:{86, 50, 38, 255}
C_LIGHT_BROWN:rl.Color:{187, 127, 87, 255}
C_DARK_GREY:rl.Color:{57, 57, 57, 255}
CAMERA_LERP_SMOOTH:f32:0.3

// VARIABLES
camera:rl.Camera2D
tex_tileset:rl.Texture2D
fnt_main:rl.Font
level:i32
xp:i32 = 0
xp_max:i32 = 10
xp_max_base:i32 = 10
xp_total:i32 = 0
xp_balance:i32 = 0

time_sec:i32 = 0
time_min:i32 = 10
time_timer:f32
time_timer_duration:f32 = 1.0
kills:i32 = 0

snd_revolver:rl.Sound
snd_mine:rl.Sound
snd_level_up:rl.Sound
snd_rock_break:rl.Sound
snd_choose_upgrade:rl.Sound
snd_upgrade_selected:rl.Sound
snd_ouch:rl.Sound
snd_player_hurt:rl.Sound
snd_game_over:rl.Sound
snd_strike_bell:rl.Sound
mus_desert:rl.Music
current_state:GamePlayState = .MAIN_MENU




