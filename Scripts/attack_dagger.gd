extends Node2D

var daño:float=2.0

var speed = 800
var direction

@export var cooldown:=1.0
@export var tieneDuracion:=false

func _ready():
	$TimerCooldown.set_wait_time(cooldown)


func _physics_process(delta):
	if direction!=null:
#		print("posicion antes: ++++"+str(position))
		global_position+= (direction * speed * delta)
#		print("Posicion despues--------- "+str(position," // Sumando: ",(direction * speed * delta)))


func _on_body_entered(body):
	print("Choco con algo!!!")
	if body.is_in_group("Enemigo"):
		print("CHOCO CONEMENIGO!!!!-----")
		body.quitar_vida(daño)
		queue_free()

func define_direction(defined_direction):
#	add_constant_central_force(direction)
	direction=defined_direction
	update_rotation()



	
func ActualizarTimerCooldown(valor:float):
	$TimerCooldown.set_wait_time(valor)

func ActualizarTimerDuracion(valor:float):
	$TimerDuracion.set_wait_time(valor)
	
func update_rotation():
	self.set_rotation(direction.angle()) 
	


func _on_timer_death_timeout():
	queue_free()
