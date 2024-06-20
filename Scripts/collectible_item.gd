extends Node2D

@export var item:Collectible


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):	
		SignalBus.collectible_found.emit(item.name)
		#print("Cogi un colecionable!")
		$AudioStreamPlayer.play()
		self.visible=false
		await get_tree().create_timer(0.8).timeout
		
		queue_free()


func set_collectible(colectible:Collectible):
	item=colectible
