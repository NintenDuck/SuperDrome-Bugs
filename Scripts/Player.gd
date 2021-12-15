extends KinematicBody2D

# warning-ignore:unused_signal
signal hit_door(door)
signal pickedUpSuGun
#signal playerDied

const Bullet = preload("res://Scenes/Player/PlayerBullet.tscn")

enum gunStates{
	NORMAL,
	SUPERGUN
}
enum{
	MOVE,
	WALLSLIDING,
	WAITING
}

export(int) var MAX_SPD = 40
export(int) var ACCEL = 350
export(float) var FRICTION = 0.2
export (int) var GRAVITY = 300
export(int) var JUMP_FORCE = 101
export(int) var FALL_SPEED = 150
export(float) var CUT_HEIGHT = 0.5

export(Texture) var currentPlayerTexture

export(float) var shootWaiTimeNormal = 0.25
export(float) var shootWaitTimeSuGun = 0.15
export(gunStates) var gunState = gunStates.NORMAL

onready var sprite = $sprite
onready var animation = $animation
onready var bulletPos = $bulletInitPos
onready var bulletUpPos = $bulletUpPos
onready var blinkAnimator = $blinkAnimator
onready var shootWaitTime = $shootWaitTime
onready var superGunDurationCounter = $superGunDurationCounter

var canShoot = true

var invinsible = false setget set_invinsible
var bulletPositionDefault

const UP = Vector2.UP

var motion = Vector2.ZERO
var DIRECTION = 0
var lastDirection = 1

var state = MOVE

func _ready():
	PlayerStats.player = self
	sprite.visible = true
	sprite.texture = currentPlayerTexture
# warning-ignore:return_value_discarded
	PlayerStats.connect("player_died", self, "_on_player_died")
	bulletPositionDefault = bulletPos.position.x

func _physics_process(delta):
	debug()
	match state:
		MOVE:
			playerPosition_global()
			apply_gravity(delta)
			movement(delta)
			checkShooting()
			check_last_direction()
			apply_friction()
			update_animations()
			jump_check()
			motion = move_and_slide( motion, Vector2.UP )
		WALLSLIDING:
			apply_gravity(delta)
			checkShooting()
		WAITING:
			motion = Vector2.ZERO
			animation.play("idle")



func checkShooting():
	checkGunMode()
	if Input.is_action_pressed("k_shoot") and shootWaitTime.time_left == 0:
		shoot()
func checkGunMode():
	match gunState:
		gunStates.NORMAL:
			shootWaitTime.wait_time = shootWaiTimeNormal
		gunStates.SUPERGUN:
			shootWaitTime.wait_time = shootWaitTimeSuGun

func _input(event):
	if event.is_action_released("k_jump"):
		if motion.y < 0:
			motion.y *= CUT_HEIGHT

func movement(delta):
	DIRECTION = int(Input.is_action_pressed("k_right")) - int(Input.is_action_pressed("k_left"))


	#Aplicamos fuerza horizontal en Vector X
	motion.x += DIRECTION * ACCEL * delta
	motion.x = clamp( motion.x, -MAX_SPD, MAX_SPD )

func check_last_direction():
	if DIRECTION != 0:
		lastDirection = DIRECTION
		if DIRECTION == 1:
			bulletPos.position.x = bulletPositionDefault
		else:
			bulletPos.position.x = -bulletPositionDefault


func apply_friction():
#	if DIRECTION == 0 and is_on_floor():
	if DIRECTION == 0:
		if is_on_floor():
			FRICTION = 0.2
		else:
			FRICTION = 0.03
		motion.x = lerp( motion.x, 0, FRICTION)

func apply_gravity(delta):
	motion.y += GRAVITY * delta
	motion.y = min( motion.y, FALL_SPEED)

func update_animations():
	if Input.is_action_pressed("k_up"):
		animation.play("shootUp")
		if DIRECTION != 0:
			sprite.scale.x = DIRECTION
	else:
		if DIRECTION != 0:
			sprite.scale.x = DIRECTION
			animation.play("walk")
		else:
			if is_on_floor() and motion.x <= 5:
				animation.play("idle")
		if not is_on_floor():
			if motion.y > 60:
				animation.play("fall")
			else:
				animation.play("jump")

func jump_check():
	if is_on_floor():
		if Input.is_action_just_pressed("k_jump"):
			jump(JUMP_FORCE)


func jump(force):
	SoundFx.play( "Jump", -5, 1, true, 1,1.5 )
	motion.y -= force

func shoot():
	if Input.is_action_pressed("k_up"):
		var bullet = Utils.instance_to_main( Bullet, bulletUpPos.global_position)
		bullet.global_position.x += rand_range(-1,1)
		bullet.velocity.x = 0
		bullet.velocity.y -= 150
		bullet.rotation_degrees = -90
	else:
		var bullet = Utils.instance_to_main( Bullet, bulletPos.global_position)
		bullet.global_position.y += rand_range(-1,1)
		bullet.velocity.x *= lastDirection
		bullet.scale.x *= lastDirection
	shootWaitTime.start()
func debug():

	pass

# Cuando hagan daño al jugador
#(IMPLEMENTAR)

func _on_HurtBox_hit(damage):
	if invinsible == false:
		PlayerStats.health -= damage
		#Debug modify
#		print("Current Health: ", str(PlayerStats.health))
		SoundFx.play("PlayerHurtSFX")
		blinkAnimator.play("blink")

func _on_player_died():
	restore_playerStats()
	pass

func restore_playerStats():
	PlayerStats.health += 3

func set_invinsible(value):
	invinsible = value

func playerPosition_global():
	PlayerStats.currentPlayerPosition = global_position

func _on_PickupDetector_area_entered(pickup):
	var Type = pickup.Type
	match pickup.Current_Pickup:
		Type.TACO:
			PlayerStats.health += 1
			print(PlayerStats.health)
		Type.SUPERGUN:
			PlayerStats.hasSuperGun = true
			gunState = gunStates.SUPERGUN
			superGunDurationCounter.start()
			emit_signal("pickedUpSuGun")
	pickup.emit_signal("pickedup")

func step():
	SoundFx.play("Step", -10, 1,true,1.3,1.4)

func _on_superGunDurationCounter_timeout():
	PlayerStats.hasSuperGun = false
	gunState = gunStates.NORMAL
