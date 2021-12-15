extends Control

var can_skip = false
var skip_pressed = false

# warning-ignore:unused_argument
func _process(delta):
	if can_skip:
		if skip_pressed == false:
			if Input.is_action_just_pressed("Paused_Button"):
				skip_pressed = true
				go_to_main_menu()

func activate_skip():
	can_skip = true
	
func go_to_main_menu():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Levels/Menu_Principal.tscn")


