extends Node2D


@export var item:Collectible



func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):	
		SignalBus.collectible_found.emit(item.name)
		queue_free()



func set_colectible(colectible:Collectible):
	item=colectible



