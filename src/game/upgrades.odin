package game

import rl "../../raylib"

MAX_UPGRADES::9
UpgradeType::enum{
	SHOOTER,
	MINER,
	BOTH
}

UpgradeId::enum{
	YOUNG_SLINGER,
	THE_COLT,
	BLONDIES_PROWES,
	I_WILL_HELP,
	VETERAN,
	ANTI_SLACKER,
	COME_GET_ME,
	LUCKY_STRIKE,
	CHILL
}

Upgrade::struct{
	name: cstring,
	id: UpgradeId,
	type: UpgradeType,
	desc1:cstring,
	desc2:cstring,
	desc3:cstring,
	desc4:cstring,
	desc5:cstring,
	is_active:bool,
	no_of_uses:int
}

upgradeTypeName:[UpgradeType]cstring= {
	.SHOOTER = "Shooter",
	.MINER = "Miner",
	.BOTH = "Both"
}

upgrades:[MAX_UPGRADES]Upgrade

upgrades_create::proc(){
	upgrades[0] = {
		name = "Young Slinger",
		id = .YOUNG_SLINGER,
		type = .SHOOTER,
		desc1 = "Increased movement",
		desc2 = "speed",
		no_of_uses = 4
	}

	upgrades[1] = {
		name = "The Colt",
		id = .THE_COLT,
		type = .SHOOTER,
		desc1 = "Increased damage",
		desc2 = "to all weapons",
		no_of_uses = 4
	}

	upgrades[2] = {
		name = "Blondie's Prowess",
		id = .BLONDIES_PROWES,
		type = .SHOOTER,
		desc1 = "Increased rate",
		desc2 = "of fire",
		no_of_uses = 4
	}

	upgrades[3] = {
		name = "I Will Help",
		id = .I_WILL_HELP,
		type = .SHOOTER,
		desc1 = "A chance for",
		desc2 = "dead enemies",
		desc3 = "to drop gold",
		no_of_uses = 4
	}

	upgrades[4] = {
		name = "Veteran",
		id = .VETERAN,
		type = .MINER,
		desc1 = "Increased speed",
		desc2 = "of mining",
		no_of_uses = 4
	}

	upgrades[5] = {
		name = "Anti-slacker",
		id = .ANTI_SLACKER,
		type = .MINER,
		desc1 = "Increased movement",
		desc2 = "speed",
		no_of_uses = 4
	}

	upgrades[6] = {
		name = "Come Get Me",
		id = .COME_GET_ME,
		type = .MINER,
		desc1 = "Increased yeild",
		desc2 = "from mining",
		no_of_uses = 4
	}

	upgrades[7] = {
		name = "Lucky Strike",
		id = .LUCKY_STRIKE,
		type = .MINER,
		desc1 = "A chance to kill",
		desc2 = "an enemy on",
		desc3 = "gaining gold",
		no_of_uses = 4
	}

	upgrades[8] = {
		name = "Chill",
		id = .CHILL,
		type = .MINER,
		desc1 = "A chance to slow",
		desc2 = "enemy movement",
		desc3 = "while gaining",
		desc4 = "gold",
		no_of_uses = 4
	}


}
upgrades_update::proc(){}
upgrades_draw::proc(){}
upgrades_draw_gui::proc(){}

activate_upgrade::proc(_upgrade_id:i32){
	if upgrades[_upgrade_id].id ==.YOUNG_SLINGER{
		perk_shooter_movespeed += 12
	}

	if upgrades[_upgrade_id].id ==.THE_COLT{
		perk_shooter_damage += 1
	}

	if upgrades[_upgrade_id].id ==.BLONDIES_PROWES{
		perk_shooter_reload_speed += 0.1
	}
	
	if upgrades[_upgrade_id].id ==.I_WILL_HELP{
		perk_shooter_chance_to_drop_gold_from_shot += 5
	}

	if upgrades[_upgrade_id].id ==.ANTI_SLACKER{
		perk_miner_movespeed += 12
	}
	if upgrades[_upgrade_id].id ==.VETERAN{
		perk_miner_speed += 0.1
	}

	if upgrades[_upgrade_id].id ==.COME_GET_ME{
		perk_miner_bonus_xp += 1
	}

	if upgrades[_upgrade_id].id ==.LUCKY_STRIKE{
		perk_miner_kill_chance += 5
	}
	if upgrades[_upgrade_id].id ==.CHILL{
		perk_miner_slow_chance += 5
	}

}