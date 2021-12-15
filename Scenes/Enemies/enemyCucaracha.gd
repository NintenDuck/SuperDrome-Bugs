extends "res://Scenes/Enemies/enemyParent.gd"

enum DIRECTION {RIGHT = 1, LEFT = -1}

export(DIRECTION) var WALKING_DIRECTION

onready var sprite = $Sprite
onready var wallLeft = $wallLeft
onready var wallRight = $wallRight
onready var floorLeft = $floorLeft
onready var floorRight = $floorRight

var state
func _ready():
	state = WALKING_DIRECTION
	
# warning-ignore:unused_argument
func _physics_process(delta):
	match state:
		DIRECTION.LEFT:
			motion.x = -MAX_SPEED
			if wallLeft.is_colliding() or not floorLeft.is_colliding():
				state = DIRECTION.RIGHT
		DIRECTION.RIGHT:
			motion.x = MAX_SPEED
			if wallRight.is_colliding() or not floorRight.is_colliding():
				state = DIRECTION.LEFT
	
	sprite.scale.x = -sign(motion.x)
	motion = move_and_slide( motion )
