extends Area2D

export(int) var damage = 1

func _on_HitBox_area_entered(hurtbox):
	hurtbox.emit_signal("hit",damage)
#	var parent = hurtbox.get_parent()
#	if parent.is_in_group("player"):
#		parent.hurt_knockback()
