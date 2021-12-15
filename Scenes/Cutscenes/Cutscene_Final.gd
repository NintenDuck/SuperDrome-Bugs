extends Control

var skip_pressed = false

# warning-ignore:unused_argument
func _process(delta):
	if skip_pressed == false:
		if Input.is_action_just_pressed("Paused_Button"):
			go_to_credits()
			skip_pressed = true
		pass

func go_to_credits():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Cutscenes/Thanks_Scene.tscn")
	pass
