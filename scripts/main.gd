extends Node

var tile_scale = 2
var hovering = false
var tiles_to_clear = []
var clearning_bounds = Vector2(0.001, 0.002)
var mines_remaining = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	display_menu()
	$Grid.scale = Vector2(tile_scale, tile_scale)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hovering:
		var coords = get_viewport().get_mouse_position()
		var tile = get_clicked_tile(coords)
		$Grid.clear_hover()
		if tile:
			tile.hover_on()

func _input(event):
	if event.is_action_pressed("reset") and %GameManager.game_state == "playing":
		%GameManager.reset()
	elif event.is_action_pressed("go_back"):
		if %GameManager.game_state == "playing":
			%GameManager.go_to_main_menu()
	elif event.is_action_pressed("secondary_click"):
		var tile = get_clicked_tile(event.position)
		if tile:
			tile.toggle_flag()
	elif event.is_action_released("primary_click"):
		if %GameManager.game_state == "playing":
			hovering = false
			# Player clicks on tile
			var tile = get_clicked_tile(event.position)
			if tile and not tile.cleared:
				if not %GameManager.mines_placed:
					$Grid.place_mines(get_clicked_tile(event.position, true))
					%GameManager.mines_placed = true
				tile.clicked_on()
				check_win()
				if tile.adjacent == "0" and not tile.mine:
					recursive_clearing(get_clicked_tile(event.position, true))
				
					
	elif event.is_action_pressed("primary_click"):
		if %GameManager.game_state == "playing":
			hovering = true
			
func recursive_clearing(index):
	if $RecursiveTimer.is_stopped():
		$RecursiveTimer.wait_time = randf_range(clearning_bounds.x, clearning_bounds.y)
		$RecursiveTimer.start()
		
	var i = index
	var rows = $Grid.rows
	var cols = $Grid.cols
	var tiles = get_tree().get_nodes_in_group("tiles")
	var row = index / cols
	var col = index % rows
	# Top left
	if row > 0 and col > 0:
		if not tiles[i-cols-1].cleared and not tiles[i-cols-1].mine:
			tiles_to_clear.push_back(tiles[i-cols-1])
	# Top centre
	if row > 0:
		if not tiles[i-cols].cleared and not tiles[i-cols].mine:
			tiles_to_clear.push_back(tiles[i-cols])
	# Top right
	if row > 0 and col < cols - 1:
		if not tiles[i-cols+1].cleared and not tiles[i-cols+1].mine:
			tiles_to_clear.push_back(tiles[i-cols+1])
	# Left
	if col > 0:
		if not tiles[i-1].cleared and not tiles[i-1].mine:
			tiles_to_clear.push_back(tiles[i-1])
	# Right
	if col < cols - 1:
		if not tiles[i+1].cleared and not tiles[i+1].mine:
			tiles_to_clear.push_back(tiles[i+1])
	# Bottom left
	if col > 0 and row < rows - 1:
		if not tiles[i+cols-1].cleared and not tiles[i+cols-1].mine:
			tiles_to_clear.push_back(tiles[i+cols-1])
	# Bottom
	if row < rows - 1:
		if not tiles[i+cols].cleared and not tiles[i+cols].mine:
			tiles_to_clear.push_back(tiles[i+cols])
	# Bottom right
	if col < cols - 1 and row < rows - 1:
		if not tiles[i+cols+1].cleared and not tiles[i+cols+1].mine:
			tiles_to_clear.push_back(tiles[i+cols+1])

func get_clicked_tile(coords, index = false):
	for tile in get_tree().get_nodes_in_group("tiles"):
			var x_diff = (coords.x - $Grid.position.x) / tile_scale - tile.position.x
			var y_diff = (coords.y - $Grid.position.y) / tile_scale - tile.position.y
			
			if 0 <= x_diff and x_diff < 16 and 0 <= y_diff and y_diff < 16:
				if index:
					return get_tree().get_nodes_in_group("tiles").find(tile)
				else:
					return tile

func display_menu():
	$MenuBackground.visible = true
	$MainMenu.visible = true
	
func start_game():
	$Grid.set_dimensions(9,9)
	$Grid.create_tiles()
	$MenuBackground.visible = false
	$MainMenu.visible = false
	
func _on_explosions():
	$GameOver/AppearTimer.start()
	$Camera2D.add_trauma(0.5)
	var shake_factor = 0
	for tile in get_tree().get_nodes_in_group("tiles"):
		if not tile.flagged or tile.flagged and not tile.mine:
			tile.find_child("TileTexture").visible = false
			tile.cleared = true
		if tile.flagged and not tile.mine:
			tile.find_child("NumberTexture").visible = false
			tile.find_child("FlagTexture").visible = false
			tile.find_child("MineTexture").visible = true
			tile.find_child("WrongFlag").visible = true
		tile.find_child("QuestionTexture").visible = false
		tile.find_child("ClickTexture").visible = false
		# Trigger small explosions
		if not tile.flagged and tile.mine and not tile.find_child("ExplosionTexture").visible:
			tile.find_child("ExplosionTimer").start()
			#shake_factor += 1
			#$Camera2D.add_trauma(0.2)
	#$Camera2D.shake()
		
func check_win():
	# Check if player has won game
	var covered_tiles = 0
	for tile in get_tree().get_nodes_in_group("tiles"):
		if not tile.cleared:
			covered_tiles += 1
	if $Grid.number_of_mines == covered_tiles:
		%GameManager.win()

func _on_recursive_timer_timeout():
	if len(tiles_to_clear) > 0 and $GameManager.game_state == "playing":
		$RecursiveTimer.wait_time = randf_range(clearning_bounds.x, clearning_bounds.y)
		var tile = tiles_to_clear.pop_at(randi()%len(tiles_to_clear))
		if tile.adjacent == "0":
			var index = get_tree().get_nodes_in_group("tiles").find(tile)
			recursive_clearing(index)
		tile.clicked_on()
	else:
		$RecursiveTimer.stop()
		check_win()
