extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_easy_pressed() -> void:
	%GameManager.start_game("EASY")


func _on_medium_pressed() -> void:
	%GameManager.start_game("MEDIUM")


func _on_hard_pressed() -> void:
	pass # Replace with function body.


func _on_custom_pressed() -> void:
	pass # Replace with function body.
