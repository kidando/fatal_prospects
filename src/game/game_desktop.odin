#+build windows, linux, darwin
package game

import rl "../../raylib"

@(export)
game_init :: proc() {
	g_state = new(GameState)

	create()

	game_hot_reloaded(g_state)
}

@(export)
game_destroy :: proc() {
	free(g_state)
}

@(export)
game_frame :: proc() -> bool {
	update()
	draw()
	return !rl.WindowShouldClose()
}
