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
	collider_rect: rl.Rectangle, // x and y => offset, width and height => size
	state:AnimatedSprite
}


// CONSTANTS
WINDOW_SIZE:rl.Vector2:{1280, 720}
WORLD_SIZE:rl.Vector2:{640,360}


// VARIABLES
camera:rl.Camera2D
tex_tileset:rl.Texture2D
