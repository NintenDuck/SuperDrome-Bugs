extends Node

onready var trampoline = $Trampoline
onready var trampoline_Wall_L = $Trampoline/wall_Left
onready var trampoline_Wall_R = $Trampoline/wall_Right
onready var trampolineAnimator = $Trampoline/animation
onready var button = $Button
onready var buttonAnimator = $Button/AnimationPlayer

var PLAYER_COL_BIT = 0
var trampoline_state = false setget set_trampoline_state

func _ready():
	trampolineAnimator.play("disabled")
	change_trampoline_collisions(false,false)
	
func set_trampoline_state(value):
	if trampoline_state == false:
		yield(buttonAnimator,"animation_finished")
		activate_trampoline()
		trampoline_state = value
		

func change_trampoline_collisions(walls_state,trampoline_states):
	trampoline.set_collision_mask_bit(PLAYER_COL_BIT, trampoline_states)
	trampoline_Wall_L.set_collision_mask_bit(PLAYER_COL_BIT, walls_state)
	trampoline_Wall_R.set_collision_mask_bit(PLAYER_COL_BIT, walls_state)
	
func activate_trampoline():
	change_trampoline_collisions(true, true)
	trampolineAnimator.play("activating")
	
# warning-ignore:unused_argument
func _on_Button_body_entered(body):
	set_trampoline_state(true)
