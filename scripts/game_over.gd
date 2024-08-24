extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func _on_appear_timer_timeout():
	visible = true


func _on_reset_button_up():
	visible = false
	%GameManager.reset()


func _on_exit_button_up():
	visible = false
	%GameManager.go_to_main_menu()
	
func stop_timer():
	$AppearTimer.stop()
