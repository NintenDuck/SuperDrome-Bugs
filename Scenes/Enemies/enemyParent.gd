extends KinematicBody2D

const UP = Vector2.UP

export(int) var MAX_SPEED = 1
export(int) var GRAV

onready var stats = $EnemyStats
onready var blinkAnimator = $BlinkAnimator

var motion = Vector2.ZERO
var parent = get_parent()

func _on_HurtBox_hit(damage):
	stats.health -= damage
	if stats.health != 0:
		SoundFx.play( "Hurt", -5, 1, true, 1.2,1.5 )
	else:
		SoundFx.play( "DeathSFX", -5, 1, true, 1.2,1.5 )
	blinkAnimator.play("blink")
	
func _on_EnemyStats_enemy_died():
	queue_free()
