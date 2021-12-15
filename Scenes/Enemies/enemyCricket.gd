extends "res://Scenes/Enemies/enemyParent.gd"

enum STATES{
	WAITING,
	JUMPING
}

export(STATES) var currentState
export(int) var currentDirection
export(float) var waitingTimerWaitTime
export(int) var JUMPFORCE
export(int) var VERTICAL_VELOCITY
export var randomJumpTime = true

onready var waitingTimer = $waitingTimer
onready var animation = $AnimationPlayer
onready var wallLeft = $wallLeft
onready var wallRight = $wallRight
onready var floorRight = $floorRight
onready var floorLeft = $floorLeft
onready var sprite = $Sprite

var playerLastPosition = Vector2.ZERO
var state = currentState

func _ready():
	randomize()
	GRAV = 200
	if randomJumpTime:
		waitingTimer.wait_time = rand_range( 0.8, 1.2 )
	else:
		waitingTimer.wait_time = 1
	waitingTimer.start()
	pass
	
func _physics_process(delta):
	match state:
		STATES.WAITING:
			update_animations()
			
			motion.x = lerp( motion.x, 0, 0.3)
			if waitingTimer.time_left == 0:
				var safeJump = check_safe_jump()
				if safeJump == true:
					jump()
					state = STATES.JUMPING
				else:
					currentDirection *= -1
					waitingTimer.start()
		STATES.JUMPING:
			update_animations()
			if is_on_floor():
#				print(currentDirection)
				waitingTimer.start()
				state = STATES.WAITING
	
	sprite.scale.x = -currentDirection
	motion.y += GRAV * delta
	motion = move_and_slide( motion, UP )
		
func check_safe_jump():
	if currentDirection == -1:
		if floorLeft.is_colliding():
			return true
		else:
			return false
	elif currentDirection == 1:
		if floorRight.is_colliding():
			return true
		else:
			return false
			
func update_animations():
	if not is_on_floor():
		if motion.y > 0:
			animation.play("fall")
		else:
			animation.play("jump")
	else:
		animation.play("idle")
func jump():
	motion.y -= JUMPFORCE
	motion.x += VERTICAL_VELOCITY * currentDirection
