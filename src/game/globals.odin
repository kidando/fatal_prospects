package game

import rl "../../raylib"

// ENUMS

// STRUCTS
AnimatedSprite::struct{
	source_rect:rl.Rectangle,
	origin:rl.Vector2, // Sprite origin
	total_frames: int,
	frame_duration: f32,
	current_frame:int,
	frame_timer: f32,
	collider_rect: rl.Rectangle // x and y => offset, width and height => size
}

// CONSTANTS
WINDOW_SIZE:rl.Vector2:{768, 720}
WORLD_SIZE:rl.Vector2:{256,240}

// VARIABLES
camera:rl.Camera2D