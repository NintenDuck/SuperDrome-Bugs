extends Node

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	
# warning-ignore:unused_argument
func _process(delta):
#	handle_restart()
#	handle_fullscreen()
#	handle_quit_game()
	pass
func handle_restart():
	if Input.is_action_just_pressed("k_down"):
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
		PlayerStats.health = PlayerStats.max_health
	pass
func handle_fullscreen():
	if Input.is_action_just_pressed("fullscreen_button"):
		OS.window_fullscreen = !OS.window_fullscreen

#func handle_quit_game():
#	if Input.is_action_just_pressed("quit_button"):
#		get_tree().quit()

func instance_to_main(scene, position):
	var main = get_tree().current_scene
	var instance = scene.instance()
	main.add_child(instance)
	instance.global_position = position
	return instance
	
func instance_to_parent(parent, scene, position):
	var main = get_tree().current_scene
	print(main.name)
	var instance = scene.instance()
	main.add_child_below_node(parent, instance)
	instance.global_position = position
	return instance
