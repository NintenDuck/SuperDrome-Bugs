extends "res://Levels/levelParent.gd"

onready var playerActor = $Cutscene/Actors/player
onready var cucarachaActor = $Cutscene/Actors/cucaracha
onready var backupPosition = $Cutscene/backupPosition
onready var animation = $Cutscene/animation

var playerGameplay
var parent

func _ready():
	SoundMusic.stop()
	playerActor.visible = false
	cucarachaActor.visible = false


func _on_PlayerDetector_body_entered(player):
	print("Cutscene Start")
	playerGameplay = Prepare_For_Cutscene(player)
	animation.play("cutscene")
	
func Prepare_For_Cutscene(player):
	player.state = 2
	player.global_position = backupPosition.global_position
	return player

func Resume_Gameplay():
	playerGameplay.state = 0
	playerGameplay.global_position = playerActor.global_position
	
# warning-ignore:unused_argument
func _on_animation_animation_finished(anim_name):
	print("Cutscene Finished")
	Resume_Gameplay()
