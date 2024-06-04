extends Node2D

@export var health_given:=14.0

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.heal_player(health_given)		
		queue_free()


