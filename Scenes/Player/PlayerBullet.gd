extends "res://Scripts/bullet.gd"

const destroyedEffect = preload("res://Scenes/Utils/Effects/bulletDestroyedEffect.tscn")

export(float) var normalLifeTime = 0.25
export(float) var superGunLifeTime = 2

onready var lifeTimeTimer = $lifeTime
onready var animation = $animation
onready var sprite = $Sprite
var gunMode = normalLifeTime

func _ready():
	velocity.x = 150
# warning-ignore:return_value_discarded
	PlayerStats.connect("player_died",self,"_on_player_died")
	
	if PlayerStats.hasSuperGun:
		change_to_superGunBullet()
	else:
		change_to_normalBullet()
	lifeTimeTimer.start()
	set_process(false)

func _on_lifeTime_timeout():
	PlayerStats.hasSuperGun = false
	queue_free()

func change_to_normalBullet():
	lifeTimeTimer.wait_time = normalLifeTime
	sprite.modulate = Color(1, 1, 1)
	animation.play("shoot")
#	Input.start_joy_vibration( 0, 0.1, 0, 0.2)
	SoundFx.play( "Bullet", -5, 1, true, 1,1.2 )

func change_to_superGunBullet():
	lifeTimeTimer.wait_time = superGunLifeTime
	sprite.modulate = Color(1, 0.960784, 0.380392)
	animation.play("shootSuperGun")
	Input.start_joy_vibration( 0, 0, 0.1, 0.1)
	SoundFx.play("SuperGunSFX", 1, 1 , true, 1.5, 2)
	
func _on_player_died():
	if PlayerStats.hasSuperGun:
		change_to_normalBullet()

func _exit_tree():
	Utils.instance_to_main(destroyedEffect, global_position )
