package game

import rl "../../raylib"

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