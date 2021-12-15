extends Node2D

#signal checkpoint_reached(checkpoint_path)
export var checkPointLevel = false
export var playsMusic = false
export(String) var songName = ""

onready var playerInitPos = $playerInitPos
onready var door = $Door
onready var doorAnimator = $Door/animation_Door
onready var enemyCount = $Enemies.get_child_count()
onready var doorAlreadyOpened = false
onready var levelChanger = $levelChangerDoor

var WORLD = preload("res://Levels/World_Main.gd")

func _ready():
	playerInitPos.visible = false
	if playsMusic == true:
		SoundMusic.play(songName,-2)
		pass
	check_for_door_visible()
	check_for_player()
	check_World_is_parent()
	pass

# warning-ignore:unused_argument
func _process(delta):
# warning-ignore:shadowed_variable
	var enemyCount = $Enemies.get_child_count()
	if enemyCount == 0 and doorAlreadyOpened == false:
		doorAnimator.play("slashed")
		doorAlreadyOpened = true
	
func check_World_is_parent():
	var parent = get_parent()
	if parent is WORLD:
		parent.currentLevel = self
		print(parent.currentLevel.name)
		
func check_for_player():
	if PlayerStats.player != null:
		PlayerStats.player.global_position = playerInitPos.global_position
		
func check_for_door_visible():
	if enemyCount == 0:
		door.visible = false
