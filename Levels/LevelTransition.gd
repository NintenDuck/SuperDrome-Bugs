extends ColorRect

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("k_debug"):
		$AnimationPlayer.play("Close")
	if Input.is_action_just_pressed("k_debug_2"):
		$AnimationPlayer.play("Open")
