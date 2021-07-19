extends Node

func _input(_event):
	if Input.is_action_pressed("EXIT_GAME"):
		get_tree().quit()
