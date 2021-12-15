extends Area2D

export(int) var trampoline_force

onready var animation = $animation

func _on_Trampoline_body_entered(body):
	animation.play("jumpy")
	body.motion = Vector2.ZERO
	body.jump(trampoline_force)
