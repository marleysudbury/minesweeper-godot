extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Remove exit to desktop button if running in browser
	if OS.has_feature("web"):
		$Control/VBoxContainer/Exit.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	if %GameManager.game_state == "main_menu":
		%GameManager.start_game()


func _on_exit_pressed() -> void:
	get_tree().quit()
