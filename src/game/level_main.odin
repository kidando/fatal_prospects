package game

import rl "../../raylib"

// STRUCTS
LevelTile::struct{
	source_rect:rl.Rectangle,
	position:rl.Vector2
}

// CONSTANTS
LEVEL_SIZE:rl.Vector2:{100,100}
LEVEL_LIMIT_BUFFER::32
level_tiles:[10000]LevelTile

level_main_create::proc(){
	i := 0
	for _row:f32 = 0; _row < LEVEL_SIZE.x ; _row += 1{
		for _column:f32 = 0; _column < LEVEL_SIZE.y; _column += 1{
			_rand_chance:= rl.GetRandomValue(0,10)
			if f32(_rand_chance)<1.5{
				_rand_tile := level_get_rand_tile()
				level_tiles[i].source_rect = {_rand_tile.x,_rand_tile.y,16,16}
			}else{

				level_tiles[i].source_rect = {0,64,16,16}
			}
			level_tiles[i].position = {_row * 16, _column * 16}
			i += 1
		}
	}
}

level_main_update::proc(){

}

level_main_draw::proc(){
	for _level_tile in level_tiles{
		rl.DrawTexturePro(
			tex_tileset,
			_level_tile.source_rect,
			{_level_tile.position.x,_level_tile.position.y,16,16},
			{0,0},
			0,
			rl.WHITE
		)
	}
}

level_main_draw_gui::proc(){

}

level_get_rand_tile::proc()->rl.Vector2{

	_rand_index:= rl.GetRandomValue(0,11)

	if _rand_index == 0{
		return {0,64}
	}

	if _rand_index == 1{
		return {16,64}
	}

	if _rand_index == 2{
		return {32,64}
	}

	if _rand_index == 3{
		return {48,64}
	}

	if _rand_index == 4{
		return {64,64}
	}

	if _rand_index == 5{
		return {80,64}
	}

	if _rand_index == 6{
		return {0,80}
	}

	if _rand_index == 7{
		return {16,80}
	}

	if _rand_index == 8{
		return {32,80}
	}

	if _rand_index == 9{
		return {48,80}
	}

	if _rand_index == 10{
		return {64,80}
	}

	if _rand_index == 11{
		return {80,80}
	}

	return {0,0}
	
}