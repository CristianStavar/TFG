extends Node2D

@export var experience_given:=14.0

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.add_experience(experience_given)		
		queue_free()


func update_experience(tier:int,level:int):
	experience_given=(tier+level)/2 +5.5# 5.5
