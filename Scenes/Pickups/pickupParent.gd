extends Area2D
class_name Pickup
# warning-ignore:unused_signal
signal pickedup

const itemObtainedEffect = preload("res://Scenes/Utils/Effects/effectItemObtained.tscn")

var offset = Vector2(0,-4)
enum Type{
	NULL,
	TACO,
	SUPERGUN
}

export(Type) var Current_Pickup

func _on_pickupParent_pickedup():
	if Current_Pickup == Type.TACO:
		SoundFx.play( "TacoSFX" )
	elif Current_Pickup == Type.SUPERGUN:
		SoundFx.play( "SuperGunPickup")
	Utils.instance_to_main(itemObtainedEffect, global_position+offset)
	queue_free()
