extends Control

onready var cutsceneAnimator = $cutsceneAnimator
onready var levelTransition = $Transition/AnimationPlayer

var skip_pressed = false

func _ready():
	SoundMusic.play("WeirdMansion")
	pass
# warning-ignore:unused_argument
func _process(delta):
	if skip_pressed == false:
		if Input.is_action_just_pressed("Paused_Button"):
			cutsceneAnimator.play("skip_cutscene")
			skip_pressed = true
# warning-ignore:unused_argument
func _on_cutsceneAnimator_animation_finished(anim_name):
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Levels/World_Main.tscn")
