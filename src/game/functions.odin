package game

import rl "../../raylib"

update_animated_sprite::proc(_sprite:^AnimatedSprite){
	_sprite.frame_timer += rl.GetFrameTime()

	if _sprite.frame_timer >= _sprite.frame_duration{
		_sprite.frame_timer = 0
		_sprite.current_frame += 1
		if _sprite.current_frame >= _sprite.total_frames{
			_sprite.current_frame = 0
		}
	}
}

draw_animated_sprite::proc(_sprite:AnimatedSprite, _position:rl.Vector2, _rotation:f32 = 0, _tint:rl.Color = rl.WHITE){

	rl.DrawTexturePro(
		tex_tileset,
		_sprite.source_rect,
		{_position.x, _position.y, _sprite.source_rect.width,_sprite.source_rect.height},
		{_sprite.origin.x, _sprite.origin.y},
		_rotation,
		_tint
	)

}