extends Node2D

@onready var area:=$Sprite2D/Area2D
var coliding:=0

func _ready():
	area.add_to_group("Building")


func _on_area_2d_area_entered(area_entered):
	if area_entered.is_in_group("Building"):
		coliding+=1
		if coliding>0:
			area_entered.owner.destroy_self()


func destroy_self():
	if coliding>0:
		coliding-=1
		queue_free()





func _on_area_2d_body_entered(body):
	if body.is_in_group("Destroyable"):
			body.queue_free()
