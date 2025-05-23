extends Node2D

signal carry
var current = 0
var increment = 9
var last_frame = 81
var rewind = false

func count_up():
	if current == 9:
		current = 0
		carry.emit()
		flapback()
	else:
		if current == 0:
			rewind = false
			$Flipper.speed_scale=1
		$Flipper.play()
		current += 1


func flapback():
	rewind = true
	$Flipper.speed_scale=-10
	$Flipper.play()


func _on_flipper_frame_changed() -> void:
	if $Flipper.frame % 9 == 0 and !rewind:
		$Flipper.pause()
