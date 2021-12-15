extends Area2D

export(String, FILE) var Next_Level = ""

# warning-ignore:unused_argument
func _on_levelChangerDoor_body_entered(body):
	PlayerStats.player.emit_signal("hit_door", self)
#	print(self.filename)
