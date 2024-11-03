package game

import rl "../../raylib"
import "core:math"

GoldDepositType::enum{
	SMALL,
	WIDE,
	TALL,
	MEDIUM,
	LARGE
}

GoldDeposit::struct{
	is_active:bool,
	strikes:int,
	position:rl.Vector2,
	type: GoldDepositType,
	mine_cooldown: f32,
	mine_timer: f32,
	can_be_mined:bool,
	display_xp:bool,
	display_xp_timer:f32,
	diplay_xp_duration: f32,
	display_xp_position_shifter: f32
}

goldDepositSourceRects:[GoldDepositType]rl.Rectangle = {
	.SMALL = {96,64,16,16},
	.WIDE = {96,80,32,16},
	.TALL = {128,64,16,32},
	.MEDIUM = {144,64,32,32},
	.LARGE = {176,64,64,32}
}


goldDepositValue:[GoldDepositType]i32 = {
	.SMALL = 1,
	.WIDE = 2,
	.TALL = 2,
	.MEDIUM = 5,
	.LARGE = 10
}
goldDepositStrikes:[GoldDepositType]int = {
	.SMALL = 2,
	.WIDE = 4,
	.TALL = 4,
	.MEDIUM = 8,
	.LARGE = 12
}

MAX_GOLD_DEPOSITS::15
gold_deposits:[MAX_GOLD_DEPOSITS]GoldDeposit

obj_gold_deposit_create::proc(){
	for i:int = 0; i < MAX_GOLD_DEPOSITS; i += 1{
		gold_deposits[i] = {
			is_active = true,
			position = {
				f32(rl.GetRandomValue(10*16, (i32(LEVEL_SIZE.x) - 10)*16)),
				f32(rl.GetRandomValue(10*16, (i32(LEVEL_SIZE.y - 10))*16)),
			},
			type = get_random_gold_deposit_type(),
			mine_cooldown = 1.3,
			can_be_mined = true,
			diplay_xp_duration = 1.5
		}
	}
}
obj_gold_deposit_update::proc(){}
obj_gold_deposit_draw::proc(){
	for _deposit in gold_deposits{
		if _deposit.is_active{
			_source_rect := goldDepositSourceRects[_deposit.type]
			rl.DrawTexturePro(
				tex_tileset,
				_source_rect,
				{_deposit.position.x, _deposit.position.y, _source_rect.width,_source_rect.height},
				{0,0},
				0,
				rl.WHITE
			)
			if DEBUG_MODE && debug_show_colliders{
				rl.DrawRectangleRec(
					{_deposit.position.x, _deposit.position.y, _source_rect.width,_source_rect.height},
					DEBUG_COLLIDER_OPACITY
				)
			}
		}
	}
}
obj_gold_deposit_draw_gui::proc(){}

get_random_gold_deposit_type::proc()->GoldDepositType{
	_chance:= rl.GetRandomValue(0,10)


	if _chance == 1{
		return GoldDepositType.TALL
	}
	if _chance == 2{
		return GoldDepositType.WIDE
	}
	if _chance == 3{
		return GoldDepositType.MEDIUM
	}
	if _chance == 4{
		return GoldDepositType.LARGE
	}
	return GoldDepositType.SMALL
}

create_new_deposit::proc(){
		for &_deposit in gold_deposits{
		if !_deposit.is_active{
			_deposit.is_active = true
			_deposit.position = {
				f32(rl.GetRandomValue(10*16, (i32(LEVEL_SIZE.x) - 10)*16)),
				f32(rl.GetRandomValue(10*16, (i32(LEVEL_SIZE.y - 10))*16))
			}
			_deposit.mine_cooldown = 1.3
			_deposit.can_be_mined = true
			_deposit.diplay_xp_duration = 1.5
			_deposit.type = get_random_gold_deposit_type()
		}
	}
}