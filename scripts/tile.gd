extends Node2D

var flagged = false
var question = false
var mine = false
var cleared = false
var adjacent = "0"
var distance_from_explosion = 0.0
signal explosion

# Called when the node enters the scene tree for the first time.
func _ready():
	update_tile()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_tile():
	if mine:
		$MineTexture.visible = true
	else:
		$MineTexture.visible = false
		
	update_adjacent(adjacent)


func toggle_flag():
	if flagged:
		$FlagTexture.visible = false
		$QuestionTexture.visible = true
		question = true
		flagged = false
	elif question:
		$QuestionTexture.visible = false
		question = false
	elif not cleared:
		$FlagTexture.visible = true
		flagged = true
		
func clicked_on():
	if not flagged and not question and not cleared:
		$TileTexture.visible = false
		$DestroyedTile.play(str(randi()%2))
		$DestroyedTile.visible = true
		cleared = true
		if mine:
			$ExplosionTexture.visible = true
			explosion.emit()
			$ExplosionAnimation.visible = true
			$ExplosionAnimation.play("big_explosion")
			get_node("../../Grid").apply_distance(position)
			get_node("../../../Main")._on_explosions()
		else:
			# Recursive clearing
			if adjacent == "0":
				pass
		
func hover_on():
	if not cleared and not flagged and not question:
		$ClickTexture/ClickAnimation.play("hover_release")
		$ClickTexture/ClickAnimation.seek(0)
		
func hover_off():
	pass
	#if $ClickTexture.visible:
		#$ClickTexture.visible = false
		
func update_adjacent(n):
	adjacent = str(n)
	$NumberTexture.animation = adjacent
	
func set_distance_from_explosion(d):
	distance_from_explosion = d
	if d > 0:
		$ExplosionTimer.wait_time = d / 100

func _on_destroyed_tile_animation_finished():
	$DestroyedTile.visible = false


func _on_explosion_animation_animation_finished():
	$ExplosionAnimation.visible = false


func _on_explosion_timer_timeout():
	$ExplosionAnimation.play("small_explosion")
	$ExplosionAnimation.visible = true
	get_node("../../../Main/Camera2D").add_trauma(0.3)
