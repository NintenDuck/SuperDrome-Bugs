extends "res://Scenes/Enemies/enemyParent.gd"

const enemyFlyBullet = preload("res://Scenes/Enemies/enemyFlyBullet.tscn")
const playerBullet = preload("res://Scenes/Player/PlayerBullet.tscn")

enum DIRECTION{ LEFT = -1, RIGHT = 1}

enum STATES{
	SEARCHING,
	AMBUSH,
	ATTACKING
}

export(DIRECTION) var current_direction = DIRECTION.RIGHT
export(STATES) var current_state


onready var wallLeft = $wallLeft
onready var wallRight = $wallRight
onready var playerDetector = $playerDetector
onready var ambushTimer = $ambushTimer
onready var mouth = $mouthPosition
onready var animation = $AnimationPlayer
onready var shootTimerSearching = $shootTimerSearching

var playerPosition = Vector2.ZERO
var state = current_state
var ambush_velocity = 0

func _ready():
	randomize()
	shootTimerSearching.wait_time = randi() % 3+1
	ambush_velocity = rand_range(0.05,0.08)
	shootTimerSearching.start()
	
# warning-ignore:unused_argument
func _process(delta):
#	print("State: ", str(current_state))
#	print(shootTimerSearching.time_left)
	match state:
		STATES.SEARCHING:
			search_player()
		STATES.AMBUSH:
			ambush_player()
		STATES.ATTACKING:
			attack_player()

func search_player():
	motion.x = MAX_SPEED * current_direction
	if wallLeft.is_colliding():
		current_direction = DIRECTION.RIGHT
	elif wallRight.is_colliding():
		current_direction = DIRECTION.LEFT
		
	if shootTimerSearching.time_left == 0:
		animation.play("attack")

	if playerDetector.is_colliding():
		shootTimerSearching.stop()
		ambushTimer.start()
		state = STATES.AMBUSH
	motion = move_and_slide( motion )

func ambush_player():
	if ambushTimer.time_left != 0:
		global_position.x = lerp(global_position.x, PlayerStats.currentPlayerPosition.x, ambush_velocity )
		if wallLeft.is_colliding() or wallRight.is_colliding():
			state = STATES.SEARCHING
	else:
		state = STATES.ATTACKING
func attack_player():
	animation.play("attack")
	pass

func shoot():
	Utils.instance_to_main(enemyFlyBullet, mouth.global_position )

# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name):
	animation.play("fly")
	shootTimerSearching.start()
	state = STATES.SEARCHING
