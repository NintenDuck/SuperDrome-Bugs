extends ColorRect

var paused = false setget set_paused

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("Paused_Button"):
		self.paused = !paused
		
func set_paused(value):
	paused = value
	visible = paused
	if paused == true:
		SoundMusic.change_volume(-15)
	else:
		SoundMusic.change_volume(SoundMusic.currenDefaultVolume)
	get_tree().paused = paused
	


func _on_Resume_Button_pressed():
	SoundFx.play("Bullet")
	set_paused(false)


func _on_Quit_Button_pressed():
	SoundFx.play("Bullet")
	get_tree().quit()


func _on_FullScreen_Button_pressed():
#	SoundFx.play("Ring")
	OS.window_fullscreen = !OS.window_fullscreen
