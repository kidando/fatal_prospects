package game

import rl "../../raylib"

// ENUMS
PlayerType::enum{
	SHOOTER,
	MINER
}

// STRUCTS
Player::struct{
	position:rl.Vector2,
	current_animated_sprite:AnimatedSprite,
	is_active:bool,
	move_speed:f32,
	type: PlayerType
}

// CONSTANTS
MAX_PLAYERS::10
players:[MAX_PLAYERS]Player


// VARIABLES
anim_player_shooter_idle := AnimatedSprite{
	source_rect = {0,0,32,32},
	origin = {16,32},
	total_frames = 4,
	frame_duration = 0.2,
	collider_rect = {0,0,32,32}
}

// FUNCTIONS
obj_player_create::proc(){
	players = {}

}

obj_player_update::proc(){
	update_animated_sprite(&anim_player_shooter_idle)
}

obj_player_draw::proc(){
	draw_animated_sprite(anim_player_shooter_idle,{0,0})
}

obj_player_draw_gui::proc(){

}