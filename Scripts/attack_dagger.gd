extends Node2D

@export var attack_name:String

@export var damage:float=2.0

@export var speed = 800
var direction

@export var cooldown:=1.0
@export var tieneDuracion:=false

var separation:=false


@export var self_attack:PackedScene


@export_multiline var description:String
func _ready():
	
	#$TimerCooldown.set_wait_time(cooldown)
	var _f

func _physics_process(delta):
	if direction!=null:
#		print("posicion antes: ++++"+str(position))
		global_position+= (direction * speed * delta)
#		print("Posicion despues--------- "+str(position," // Sumando: ",(direction * speed * delta)))


func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		print("CHOCO CONEMENIGO!!!!-----: "+str(self))
		body.substract_health(damage)
		SignalBus.damage_dealt.emit(damage,attack_name)
		
		if separation:
			for angle in [-45,-90,-135,-190,135,90,45,0]:
				var radians = deg_to_rad(angle)
				var bullet = self_attack.instantiate()
				bullet.direction = Vector2(0,0).rotated(radians)
				bullet.global_position = self.global_position
				owner.add_child(bullet)
		
		queue_free()

func define_direction(defined_direction):
#	add_constant_central_force(direction)
	direction=defined_direction
	update_rotation()


func update_damage(value:float):
	damage+=value

func update_speed(value:float):
	speed+=value
	
	

	
func ActualizarTimerCooldown(valor:float):
	$TimerCooldown.set_wait_time(valor)

func ActualizarTimerDuracion(valor:float):
	$TimerDuracion.set_wait_time(valor)
	
func update_rotation():
	self.set_rotation(direction.angle()) 
	
func set_separation(value:bool):
	separation=value



func get_cooldown():
	return cooldown


func _on_timer_death_timeout():
	queue_free()
