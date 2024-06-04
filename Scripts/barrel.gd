extends Node2D


@export var dropped_item:PackedScene


func _ready():
	add_to_group("Destroyable")
	print(" Barril creado ")


func destroy_self():
	var b = dropped_item.instantiate()
	
	b.global_position=self.global_position
	get_parent().add_child.call_deferred(b)
	queue_free()
