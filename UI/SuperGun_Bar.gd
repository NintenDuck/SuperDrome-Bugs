extends Control

onready var progressBar = $TextureProgress
onready var gunDuration = $gunDurationTimer
onready var animation = $animation
func _ready():
	progressBar.visible = false
	progressBar.max_value = gunDuration.wait_time
# warning-ignore:return_value_discarded
	PlayerStats.connect("player_died",self, "_on_player_died")
# warning-ignore:unused_argument
func _process(delta):
	progressBar.value = gunDuration.time_left

func _on_player_died():
	progressBar.visible = false
	
func _on_Player_pickedUpSuGun():
	gunDuration.start()
	progressBar.visible = true
	animation.play("show_up")

func _on_gunDurationTimer_timeout():
#	progressBar.visible = false
	animation.play("hide")
