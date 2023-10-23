extends "res://Scripts/attack_dagger.gd"

var target:Node

@onready var gameManager:=get_node("/root/Main")
# Called when the node enters the scene tree for the first time.
func _ready():
	$TimerCooldown.set_wait_time(cooldown)
	ElegirObjetivo()

func _physics_process(delta):
	if target !=null:
		look_at(target.global_position)
	#		print("posicion antes: ++++"+str(position))
	#	global_position+= (direction * speed * delta)
		position=position.move_toward(target.global_position,speed*delta)

func ElegirObjetivo():
	target=gameManager.player.pick_random_nearby_enemy()
	




func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemigo"):
		print("CHOCO CONEMENIGO!!!!-----: "+str(self))
		body.quitar_vida(daño)
		queue_free()
