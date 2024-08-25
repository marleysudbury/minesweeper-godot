extends Control
var cols = 3
var rows = 3
var number_of_mines = 10
var tile = preload("res://scenes/tile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_dimensions(ncols, nrows):
	cols = ncols
	rows = nrows
	
func set_n_mines(nmines):
	number_of_mines = nmines

func clear_hover():
	for atile in get_tree().get_nodes_in_group("tiles"):
		atile.hover_off()

func place_mines(first_click):
	# Select which tiles will have mines
	var mines_allocated = 0
	var mine_allocations = []
	var tiles = get_tree().get_nodes_in_group("tiles")
	while mines_allocated < number_of_mines:
		var x = randi()%cols
		var y = randi()%rows
		var coord = Vector2(x, y)
		if coord not in mine_allocations and x*cols+y != first_click:
			mine_allocations.push_back(coord)
			tiles[x*cols+y].mine = true
			tiles[x*cols+y].update_tile()
			mines_allocated += 1
	
	for i in len(tiles):
		var adjacent_mines = 0
		var row = i / cols
		var col = i % rows
		if not tiles[i].mine:
			# Top left
			if row > 0 and col > 0:
				adjacent_mines += int(tiles[i-cols-1].mine)
			# Top centre
			if row > 0:
				adjacent_mines += int(tiles[i-cols].mine)
			# Top right
			if row > 0 and col < cols - 1:
				adjacent_mines += int(tiles[i-cols+1].mine)
			# Left
			if col > 0:
				adjacent_mines += int(tiles[i-1].mine)
			# Right
			if col < cols - 1:
				adjacent_mines += int(tiles[i+1].mine)
			# Bottom left
			if col > 0 and row < rows - 1:
				adjacent_mines += int(tiles[i+cols-1].mine)
			# Bottom
			if row < rows - 1:
				adjacent_mines += int(tiles[i+cols].mine)
			# Bottom right
			if col < cols - 1 and row < rows - 1:
				adjacent_mines += int(tiles[i+cols+1].mine)
			
			tiles[i].update_adjacent(adjacent_mines)

func create_tiles():
	# Initiate tiles in grid
	for i in cols:
		for j in rows:
			var new_instance = tile.instantiate()
			new_instance.set_position(Vector2(j*16, i*16))
			new_instance.add_to_group("tiles")
			add_child(new_instance)
			
func delete_tiles():
	# Remove all tile objects
	for tile in get_tree().get_nodes_in_group("tiles"):
		tile.queue_free()
		
func apply_distance(pos):
	# After explosion is triggered, apply distance from explosion to all tiles
	for atile in get_tree().get_nodes_in_group("tiles"):
		atile.set_distance_from_explosion(atile.position.distance_to(pos))
		
	
		
