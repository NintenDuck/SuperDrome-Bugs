extends Control

onready var animator = $Buttons/buttonAnimator

onready var arrow_up = $Buttons/arrow_up
onready var arrow_left = $Buttons/arrow_left
onready var arrow_right = $Buttons/arrow_right

onready var button_a = $Buttons/button_a
onready var key_k = $Buttons/key_k
onready var button_x = $Buttons/button_x
onready var key_l = $Buttons/key_l

	
# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_pressed("k_up"):
		arrow_up.frame = 1
	else:
		arrow_up.frame = 0
	if Input.is_action_pressed("k_left"):
		arrow_left.frame = 1
	else:
		arrow_left.frame = 0
	if Input.is_action_pressed("k_right"):
		arrow_right.frame = 1
	else:
		arrow_right.frame = 0
	if Input.is_action_pressed("k_jump"):
		button_a.frame = 1
		key_k.frame = 1
	else:
		button_a.frame = 0
		key_k.frame = 0
	if Input.is_action_pressed("k_shoot"):
		button_x.frame = 1
		key_l.frame = 1
	else:
		button_x.frame = 0
		key_l.frame = 0


# warning-ignore:unused_argument
func _on_PlayerDetector_body_entered(body):
	animator.play("start_game")
	PlayerStats.player.state = 2

func start_game():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Cutscenes/Cutscene_1.tscn")
