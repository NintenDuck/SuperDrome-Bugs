extends Area2D


onready var animation = $AnimationPlayer

# warning-ignore:unused_argument
func _on_Button_body_entered(body):
	SoundFx.play("Button")
	animation.play("pushing")
	yield(animation,"animation_finished")
