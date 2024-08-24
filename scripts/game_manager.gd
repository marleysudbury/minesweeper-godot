extends Node

var game_state = "main_menu"
var mines_placed = false


# Called when the node enters the scene tree for the first time.
func _ready():
	game_state = "main_menu"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func win():
	game_state = "win_screen"
	get_node("../WinScreen").visible = true
	
func lose():
	game_state = "lose_screen"
	pass
	
func reset():
	mines_placed = false
	# Reset tiles
	for tile in get_tree().get_nodes_in_group("tiles"):
		tile.queue_free()
	get_node("../Grid").create_tiles()
