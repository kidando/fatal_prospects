package game

import rl "../../raylib"


// ENUMS
AnimationState::enum{
	IDLE,
	RUN,
	DIE
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

// CONSTANTS
WINDOW_SIZE:rl.Vector2:{1280, 720}
WORLD_SIZE:rl.Vector2:{640,360}

C_YELLOW:rl.Color:{246, 205, 38, 255}
C_BLACK:rl.Color:{13, 23, 32, 255}
C_DARK_BROWN:rl.Color:{86, 50, 38, 255}
C_LIGHT_BROWN:rl.Color:{187, 127, 87, 255}
C_DARK_GREY:rl.Color:{57, 57, 57, 255}

// VARIABLES
camera:rl.Camera2D
tex_tileset:rl.Texture2D
fnt_main:rl.Font
level:i32
xp:i32
xp_max:i32