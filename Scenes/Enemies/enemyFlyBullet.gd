extends "res://Scripts/bullet.gd"

const PLAYER_BIT = 3
const WORLD_BIT = 2

onready var animation = $animation
onready var hitbox = $HitBox

func _ready():
	animation.connect("animation_finished", self, "_anim_finished")
	
# warning-ignore:unused_argument
func _on_HitBox_body_entered(body):
	deactivate_coll_w_player()
	velocity = Vector2.ZERO
	animation.play("crash")

# warning-ignore:unused_argument
func _on_HitBox_area_entered(area):
	deactivate_coll_w_player()
	velocity = Vector2.ZERO
	animation.play("crash")

func _anim_finished(_anim_name):
	queue_free()

func deactivate_coll_w_player():
	hitbox.set_collision_mask_bit(2,false)
