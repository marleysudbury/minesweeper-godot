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
	get_node("../GameOver/AppearTimer").start()
	
func lose():
	game_state = "lose_screen"
	pass
	
func reset():
	clear_tiles()
	get_node("../Grid").create_tiles()
	
	get_node("../RecursiveTimer").stop()
	get_node("../GameOver").stop_timer()
	get_node("../WinScreen").visible = false
	get_node("../GameOver").visible = false
	get_node("../../Main").tiles_to_clear = []
	
	game_state = "playing"
	
func clear_tiles():
	mines_placed = false
	# Reset tiles
	for tile in get_tree().get_nodes_in_group("tiles"):
		tile.queue_free()
	
func go_to_main_menu():
	game_state = "main_menu"
	get_node("../../Main").display_menu()
	get_node("../WinScreen").visible = false
	get_node("../GameOver").visible = false
	
func open_game_menu():
	# Choose difficulty level
	clear_tiles()
	%GameManager.game_state = "game_menu"
	get_node("../MenuBackground").visible = true
	get_node("../GameMenu").visible = true
	get_node("../MainMenu").visible = false
		
func start_game(mode):
	game_state = "playing"
	if mode == "EASY":
		get_node("../Grid").scale = Vector2(2.0, 2.0)
		get_node("../../Main").start_game()
	if mode == "MEDIUM":
		get_node("../Grid").scale = Vector2(1.0, 1.0)
		get_node("../../Main").start_game()
