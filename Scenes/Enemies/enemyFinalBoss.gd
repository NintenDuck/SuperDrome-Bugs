extends "res://Scenes/Enemies/enemyParent.gd"

const dustEffects = preload("res://Scenes/Utils/Effects/effectItemObtained.tscn")


enum STATES{
	CUTSCENE,
	CUTSCENE_2
	IDLE,
	CHECKING_PLAYER_POSITION,
	JUMP_TO_PLAYER,
	GOING_UP,
	GOING_DOWN,
	RANDJUMP,
	PUNCHING,
	CHARGE_TO_PLAYER,
	LANDING
}

const PLAYER_BIT = 1
const HURTBOX_BIT = 3
const HITBOX_BIT = 2

onready var idleTimer = $IdleTimer
onready var fallTimer = $fallTimer
onready var initJumpPos = $Jump_to_player_Positions/InitPos
onready var lastPlayerPos = $Jump_to_player_Positions/FinalPos
onready var animator = $AnimationPlayer
onready var raycastCeilling = $Raycasts/raycastCeiling
onready var raycastFloor = $Raycasts/raycastFloor
onready var hurtBox = $HurtBox
onready var hitBox = $HitBox

export(STATES) var currentState = STATES.CUTSCENE
export(int) var jumpVelocity

var playerPosBeforeJump = Vector2.ZERO
var bossPosBeforeJump = Vector2.ZERO
var alreadyCollided = false
var state = currentState
var idleTimerActive = false
var dead = false

# warning-ignore:unused_argument
func _physics_process(delta):
	match state:
		STATES.CUTSCENE:
			set_collisions_to(false)
			animator.play("cutscene_1")
			yield(animator,"animation_finished")
			set_collisions_to(true)
			change_state_to(STATES.IDLE)
		STATES.CUTSCENE_2:
			pass
		STATES.IDLE:
			idle()
		STATES.RANDJUMP:
			pass
		STATES.CHECKING_PLAYER_POSITION:
			check_for_player_position()
		STATES.JUMP_TO_PLAYER:
			Jump_to_player()
		STATES.GOING_UP:
			go_up()
		STATES.GOING_DOWN:
			go_down()
		STATES.PUNCHING:
			pass
		STATES.LANDING:
			landing()
		STATES.CHARGE_TO_PLAYER:
			pass
func idle():
	animator.play("idle")
	if idleTimerActive == false:
		idleTimer.start()
		idleTimerActive = true
	if idleTimer.time_left == 0:
		idleTimerActive = false
		change_state_to(STATES.CHECKING_PLAYER_POSITION)

func check_for_player_position():
	initJumpPos.global_position = global_position
	lastPlayerPos.global_position = PlayerStats.player.global_position
	
	playerPosBeforeJump = lastPlayerPos.global_position
	bossPosBeforeJump = initJumpPos.global_position
	
	change_state_to(STATES.JUMP_TO_PLAYER)
	
func Jump_to_player():
	animator.play("prep_jump")
	yield(animator,"animation_finished")
	if dead == true:
		change_state_to(STATES.CUTSCENE_2)
	generateDust(5,7)
	Input.start_joy_vibration(0,1,0,1)
	SoundFx.play("BossJump",-10,1,true,1,1.5)
	
	change_state_to(STATES.GOING_UP)

func go_up():
	if raycastCeilling.is_colliding():
		motion = Vector2.ZERO
		if alreadyCollided == false:
			fallTimer.start()
			alreadyCollided = true
		if fallTimer.time_left == 0:
			SoundFx.play("BossFalling",1,1,true,1,1.5)
			change_state_to(STATES.GOING_DOWN)
	else:
		lastPlayerPos.global_position = bossPosBeforeJump
		lastPlayerPos.global_position.x += rand_range(-50,50)
		initJumpPos.global_position = playerPosBeforeJump
		animator.play("jump")
		motion.y -= jumpVelocity
	
	motion = move_and_slide(motion)
func go_down():
#	motion.x = playerPosBeforeJump.x
	global_position.x = playerPosBeforeJump.x 
	motion.y += jumpVelocity
	motion = move_and_slide(motion)
	if raycastFloor.is_colliding():
		generateDust(12, 15)
		SoundFx.play("BossHitGround",1,1,true,1,1.5)
		Input.start_joy_vibration(0,0,1,1)
		change_state_to(STATES.LANDING)

func landing():
	animator.play("prep_jump")
	yield(animator,"animation_finished")
	if dead == true:
		change_state_to(STATES.CUTSCENE_2)
	change_state_to(STATES.IDLE)
	
func set_collisions_to(value):
	hitBox.set_collision_mask_bit(HITBOX_BIT, value)
	hurtBox.set_collision_layer_bit(HURTBOX_BIT, value)
	
func change_state_to(newState):
	state = newState
#	match state:
#		STATES.IDLE:
#			print("Current State: IDLE")
#		STATES.RANDJUMP:
#			print("Current State: RANDOM JUMPING")
#		STATES.CHECKING_PLAYER_POSITION:
#			print("Current State: CHECKING PLAYER POSITION")
#		STATES.JUMP_TO_PLAYER:
#			print("Current State: JUMP TO PLAYER")
#		STATES.PUNCHING:
#			print("Current State: PUNCHING")
#		STATES.CHARGE_TO_PLAYER:
#			print("Current State: CHARGE TO PLAYER")
#		STATES.GOING_UP:
#			print("Current State: GOING UP")
#		STATES.GOING_DOWN:
#			print("Current State: GOING DOWN")
#		STATES.CUTSCENE:
#			print("Current State: CUTSCENE_1")
#		STATES.CUTSCENE_2:
#			print("Current State: CUTSCENE_2")

func generateDust(amount,range_x = 0,range_y = 0):
# warning-ignore:unused_variable
	for i in range(amount):
			Utils.instance_to_main(dustEffects,global_position + Vector2(rand_range(-range_x,range_x),rand_range(0,-range_y)))

func _on_EnemyStats_enemy_died():
	idleTimer.stop()
	fallTimer.stop()
	dead = true
	Input.start_joy_vibration(0,0,1,1.5)
	generateDust(20,15,50)
	set_collisions_to(false)
	var parent_of_parent = get_parent().get_parent()
	parent_of_parent.bossLastPos = global_position
	print(parent_of_parent.bossLastPos)
	animator.play("death")
	yield(animator,"animation_finished")
	queue_free()
#	change_state_to(STATES.CUTSCENE_2)
	
func _on_HurtBox_hit(damage):
	stats.health -= damage
	if stats.health != 0:
		SoundFx.play( "BossHit", 1, 1, true, 1.2,1.5 )
	else:
		SoundFx.play( "DeathSFX", -5, 1, true, 1.2,1.5 )
	blinkAnimator.play("blink")
	
func play_boss_music():
	SoundMusic.play("BossTheme")
	pass
