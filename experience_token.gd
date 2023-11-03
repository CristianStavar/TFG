extends Node2D

@export var experience_given:=1.0

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.add_experience(experience_given)		
		queue_free()
