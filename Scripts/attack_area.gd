extends Node


var daño:float=1.0

var speed = 800
var direction

@export var cooldown:=1.0
@export var tieneDuracion:=false
@export var nombreGrupoArea:=""
@export var cooldownDaño:=0.3

var cuerposDentro:Array

# Called when the node enters the scene tree for the first time.
func _ready():
	$"TimerDañar".set_wait_time(cooldownDaño)



func _on_body_entered(body):
	print("Entra en AREA")
	if body.is_in_group("Enemigo")and not body.is_in_group(nombreGrupoArea):
		cuerposDentro.append(body)
		body.add_to_group(nombreGrupoArea)
		body.quitar_vida(daño)

		
		
func _on_timer_timeout():
	queue_free()
	
func DañarEnemigosDentro():
	if cuerposDentro.size()>0:
		for i in cuerposDentro.size():
			cuerposDentro[i].quitar_vida(daño)


func _on_body_exited(body):
	if body.is_in_group("Enemigo"):
		cuerposDentro.erase(body)
		body.remove_from_group(nombreGrupoArea)


func _on_timer_dañar_timeout():
	DañarEnemigosDentro()


func _on_timer_desaparicion_timeout():
	queue_free()
