extends Node

onready var player = null

var max_health = 3
var health = max_health setget set_health
var currentPlayerPosition = null
var hasSuperGun = false setget set_hasSuperGun

signal player_died
signal player_health_changed

func _ready():
# warning-ignore:return_value_discarded
	connect("player_died",self,"_on_player_died")

func set_health(value):
	health = clamp( value, 0, max_health )
	emit_signal("player_health_changed")
	if health <= 0:
		emit_signal("player_died")

func set_hasSuperGun(value):
	hasSuperGun = value

func _on_player_died():
	hasSuperGun = false
	player.gunState = player.gunStates.NORMAL
