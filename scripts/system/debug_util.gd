extends Node

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("escape"):
			get_tree().quit()
		if Input.is_action_just_pressed("fullscreen"):
			OS.window_fullscreen = !OS.window_fullscreen
		if Input.is_action_just_pressed("reset"):
			get_tree().reload_current_scene()
		
	if event is InputEventScreenTouch:
		if event.pressed && event.index == 3:
			get_tree().reload_current_scene()