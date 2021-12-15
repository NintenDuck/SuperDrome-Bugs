extends Node
class_name World_Main

onready var currentLevel
onready var currentCheckpoint = currentLevel
onready var levelTransition = $UI/Transition/AnimationPlayer
onready var checkPointAnimator = $UI/checkPoint/checkPointAnimation
onready var checkPointLabel = $"UI/checkPoint/Margin Container/Label"

func _ready():
# warning-ignore:return_value_discarded
	PlayerStats.connect("player_died",self,"_on_player_died")
	levelTransition.play("Open")
	checkPointLabel.visible = false
#	print(currentLevel.name)
	
func _on_levelChangerDoor_playerTouchedDoor():
	levelTransition.play("Close")
	
func change_level_to(door):
	currentLevel.queue_free()
	var NewLevel = load(door.Next_Level)
	var newLevel = NewLevel.instance()
	check_for_checkpoint(newLevel)
	add_child(newLevel)
	
func change_level_on_death(level_path:String):
	currentLevel.queue_free()
	var NewLevel = load(level_path)
	var newLevel = NewLevel.instance()
	add_child(newLevel)
	
func check_for_checkpoint(newLevel):
	if newLevel.checkPointLevel == true:
		currentCheckpoint = newLevel.filename
		checkPointAnimator.play("animate")
		print("New Checkpoint is: " + newLevel.name)
		
func fade_in():
	levelTransition.play("Close")
	SoundFx.play("TransitionSteps",10,1,true,1,1.1)
	Input.start_joy_vibration(0,0,0.1,1)
#	if levelTransition.aniamtion

func fade_out():
	levelTransition.play("Open")

func _on_Player_hit_door(door):
	fade_in()
	PlayerStats.player.state = 2
	yield(levelTransition,"animation_finished")
	call_deferred("change_level_to", door)
	fade_out()
	yield(levelTransition,"animation_finished")
	PlayerStats.player.state = 0

func _on_player_died():
	fade_in()
	PlayerStats.player.state = 2
	yield(levelTransition,"animation_finished")
	call_deferred("change_level_on_death",currentCheckpoint)
	fade_out()
	yield(levelTransition,"animation_finished")
	PlayerStats.player.state = 0
	pass
