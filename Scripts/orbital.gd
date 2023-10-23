extends Node2D

var daño:float=2.0

var speed = 800
var direction

@export var cooldown:=1.0
@export var tieneDuracion:=false

var tiempo:=0.0
var radius:=36.0
var speedRotation:=5.0

func _ready():
#	$TimerCooldown.set_wait_time(cooldown)
	pass


func _physics_process(delta):
	tiempo+=delta
	position=Vector2(sin(tiempo*speedRotation)*radius,cos(tiempo*speedRotation)*radius)



func _on_body_entered(body):
	print("Choco con algo!!!")
	if body.is_in_group("Enemigo"):
		print("CHOCO CONEMENIGO!!!!-----")
		body.quitar_vida(daño)
#		queue_free()

func definir_direccion(direccion):
#	add_constant_central_force(direction)
	direction=direccion

#
#func _on_timer_timeout():
#	queue_free()
	
func ActualizarTimerCooldown(valor:float):
	$TimerCooldown.set_wait_time(valor)

func ActualizarTimerDuracion(valor:float):
	$TimerDuracion.set_wait_time(valor)

func AumentaTamaño(valor:float):
	self.set_scale(get_scale()*valor)

	pass
