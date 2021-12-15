extends Control

onready var lifeTexture = $lifeFull
onready var animation = $animation

var textureSize = 11
#var textureSize = 8

func _ready():
	lifeTexture.visible = true
# warning-ignore:return_value_discarded
	PlayerStats.connect("player_health_changed",self, "_on_player_hp_changed")

func _on_player_hp_changed():
	if PlayerStats.health != 0:
		lifeTexture.rect_size.x = PlayerStats.health * textureSize
	else:
		lifeTexture.rect_size.x = 0
	if PlayerStats.health == 1:
		animation.play("healthChanged")
		yield(animation,"animation_finished")
		animation.play("blink")
	else:
		animation.play("healthChanged")
