extends Node2D


@export var dropped_item:PackedScene


func _ready():
	add_to_group("Destroyable")
#	print(" Barril creado ")


func destroy_self():
	var b = dropped_item.instantiate()
	
	
	SignalBus.barrel_destroyed.emit()
	get_parent().get_parent().add_child.call_deferred(b)
	b.global_position=self.global_position
	queue_free()
