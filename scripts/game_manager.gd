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
	get_node("../CustomGameMenu").visible = true
	get_node("../MainMenu").visible = false


func start_game(mode):
	game_state = "playing"
	var grid = get_node("../Grid")
	var main = get_node("../../Main")
	var rows
	var cols
	var mines
	var scale_factor
	var window_size = get_viewport().get_visible_rect().size
	var centre_point = Vector2(window_size.x/2, window_size.y/2)
	if mode == "EASY":
		rows = 9
		cols = 9
		mines = 10
		scale_factor = 2.0
	elif mode == "MEDIUM":
		rows = 16
		cols = 16
		mines = 40
		scale_factor = 1.0
	elif mode == "HARD":
		rows = 16
		cols = 30
		mines = 99
		scale_factor = 1.0
	elif mode == "CUSTOM":
		rows = int(get_node("../CustomGameMenu/TextBoxes/RowText").text)
		cols = int(get_node("../CustomGameMenu/TextBoxes/ColText").text)
		mines = int(get_node("../CustomGameMenu/TextBoxes/MineText").text)
		scale_factor = 1.0
		if rows < 9 or rows > 16 or cols < 9 or cols > 16 or mines < 1 or mines > rows*cols-1:
			open_game_menu()
			return
	
	grid.position = Vector2(centre_point.x - cols*16*scale_factor/2, centre_point.y - rows*16*scale_factor/2)
	grid.scale = Vector2(scale_factor, scale_factor)
	grid.set_dimensions(cols, rows)
	grid.set_n_mines(mines)
	main.start_game()
