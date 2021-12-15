extends Node2D

export var velocity = Vector2.ZERO

func _process(delta):
	move(delta)
	pass
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func move(delta):
	position += velocity * delta

# warning-ignore:unused_argument
func _on_HitBox_body_entered(body):
	queue_free()

# warning-ignore:unused_argument
func _on_HitBox_area_entered(area):
	queue_free()
