extends Node2D

@export var attack_name:String
var damage:float=2.0

var speed = 800
var direction

@export var cooldown:=1.0
@export var solid_shield:=false


var time:=0.0
var radius:=36.0
var speedRotation:=5.0

func _ready():
#	$TimerCooldown.set_wait_time(cooldown)
	add_to_group("Orbital")


func _physics_process(delta):
	time+=delta
	position=Vector2(sin(time*speedRotation)*radius,cos(time*speedRotation)*radius)



func _on_body_entered(body):
	print("Choco con algo!!!")
	if body.is_in_group("Enemy"):
		print("CHOCO CONEMENIGO!!!!-----")
		body.quitar_vida(damage)
		SignalBus.damage_dealt.emit(damage,attack_name)
	if solid_shield and body.is_in_group("EnemyBullet"):
		body.self_destruct()
	
		
		
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
