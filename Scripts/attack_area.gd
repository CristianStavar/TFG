extends Node


var damage:float=1.0

var speed = 800
var direction

@export var cooldown:=1.0
@export var has_duration:=false
@export var area_group_name:=""
@export var cooldown_damage:=0.3

var bodies_inside:Array

# Called when the node enters the scene tree for the first time.
func _ready():
	$"TimerDañar".set_wait_time(cooldown_damage)



func _on_body_entered(body):
	print("Entra en AREA")
	if body.is_in_group("Enemigo")and not body.is_in_group(area_group_name):
		bodies_inside.append(body)
		body.add_to_group(area_group_name)
		body.quitar_vida(damage)

		
		
func _on_timer_timeout():
	queue_free()
	
func DañarEnemigosDentro():
	if bodies_inside.size()>0:
		for i in bodies_inside.size():
			bodies_inside[i].quitar_vida(damage)


func _on_body_exited(body):
	if body.is_in_group("Enemigo"):
		bodies_inside.erase(body)
		body.remove_from_group(area_group_name)


func _on_timer_dañar_timeout():
	DañarEnemigosDentro()


func _on_timer_desaparicion_timeout():
	queue_free()
