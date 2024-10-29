package game

import rl "../../raylib"

update_animated_sprite :: proc(_sprite: ^AnimatedSprite) {
	_sprite.frame_timer += rl.GetFrameTime()

	if _sprite.frame_timer >= _sprite.frame_duration {
		_sprite.frame_timer = 0
		_sprite.current_frame += 1
		if _sprite.current_frame >= _sprite.total_frames {
			_sprite.current_frame = 0
		}
	}
}

draw_animated_sprite :: proc(
	_sprite: AnimatedSprite,
	_position: rl.Vector2,
	_is_flipped: bool = false,
	_rotation: f32 = 0,
	_tint: rl.Color = rl.WHITE,
) {

	_flip_factor: f32 = 1
	if _is_flipped {
		_flip_factor = -1
	}

	rl.DrawTexturePro(
		tex_tileset,
		{
			_sprite.source_rect.x + (f32(_sprite.current_frame) * _sprite.source_rect.width),
			_sprite.source_rect.y,
			_sprite.source_rect.width * _flip_factor,
			_sprite.source_rect.height,
		},
		{_position.x, _position.y, _sprite.source_rect.width, _sprite.source_rect.height},
		{_sprite.origin.x, _sprite.origin.y},
		_rotation,
		_tint,
	)

	if DEBUG_MODE && debug_show_colliders {
		rl.DrawRectangleRec(
			{
				_position.x - _sprite.collider_rect.x,
				_position.y - _sprite.collider_rect.y,
				_sprite.collider_rect.width,
				_sprite.collider_rect.height,
			},
			{255, 0, 0, DEBUG_COLLIDER_OPACITY},
		)
	}

}
