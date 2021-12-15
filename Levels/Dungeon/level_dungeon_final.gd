extends "res://Levels/levelParent.gd"

onready var bossActor = $Cutscene/bossActor
onready var bossActorAnimator = $Cutscene/bossActor/Sprite/bossAnimator
onready var colorRect = $CanvasLayer/Fade/ColorRect
onready var fadeAnimator  = $scene_Animator
var bossLastPos = Vector2.ZERO

func _ready():
	SoundMusic.play("BossTheme")
	colorRect.color = 00000000

func _on_enemyFinalBoss_tree_exited():
	bossActorAnimator.play("cutscene_death")
	SoundMusic.stop()
	bossActor.global_position = bossLastPos
	pass


# warning-ignore:unused_argument
func _on_playerDetector_body_entered(body):
	fadeAnimator.play("fade")
	PlayerStats.player.state = 2

func go_to_final_scene():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Cutscenes/Cutscene_Final.tscn")
