extends Control

signal carry
var current = 0
var increment = 9
var last_frame = 81
var rewind = false
var fastforward = false
var target = 0

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


func reset():
	current = 0
	flapback()


func go_to(i):
	current = i
	$Flipper.frame = i * increment


func go_to_animate(i, speed=1):
	target = i
	if i * increment < $Flipper.frame:
		fastforward = true
		$Flipper.speed_scale=-speed
		$Flipper.play()
	elif i * increment > $Flipper.frame:
		fastforward = true
		$Flipper.speed_scale=speed
		$Flipper.play()
	current = i


func _on_flipper_frame_changed() -> void:
	if fastforward and $Flipper.frame == target * increment:
		$Flipper.pause()
		fastforward = false
	elif !fastforward:
		if $Flipper.frame % 9 == 0 and !rewind:
			$Flipper.pause()
		if $Flipper.frame == 0 and rewind:
			$Flipper.pause()
