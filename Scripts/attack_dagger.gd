extends Node2D

@export var attack_name:String

@export var damage:float=2.0

@export var speed = 800
var direction

@export var cooldown:=1.0


var separation:=false

@onready var colision:=$Area2D/CollisionShape2D

var self_attack:PackedScene

@export var show_name:String
@export_multiline var description:String
@export_multiline var unique_upgrades:String

var is_shard:=false
func _ready():
	self_attack=load("res://Ataques/Propios/attack_dagger.tscn")
	#$TimerCooldown.set_wait_time(cooldown)


func _physics_process(delta):
	if direction!=null:
#		print("posicion antes: ++++"+str(position))
		global_position+= (direction * speed * delta)
#		print("Posicion despues--------- "+str(position," // Sumando: ",(direction * speed * delta)))


func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		body.substract_health(damage)
		if is_shard:
			SignalBus.damage_dealt.emit(damage,"Hammer")
		else:
			SignalBus.damage_dealt.emit(damage,attack_name)
		
		if separation:
			var i:=0
			for angle in [-90,-190,90,0]:
				
				var radians = deg_to_rad(angle)
				var bullet = self_attack.instantiate()
				
				bullet.set_separation(false)
				bullet.update_damage(damage)
				bullet.update_speed(speed)
				bullet.define_direction( Vector2(1,0).rotated(radians))
				get_parent().add_child.call_deferred(bullet)
				
				if i==0:
					bullet.global_position = self.global_position+Vector2(0,-20)
				elif i==1:
					bullet.global_position = self.global_position+Vector2(-35,0)
				elif i==2:
					bullet.global_position = self.global_position+Vector2(0,25)
				elif i==3:
					bullet.global_position = self.global_position+Vector2(25,0)
				i+=1
#				bullet.colision.set_deferred("disabled",true)
#				await get_tree().create_timer(0.2).timeout
#				bullet.colision.set_deferred("disabled",false)
		
		queue_free()
		
	if body.is_in_group("Destroyable"):
		body.destroy_self()
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

func set_is_shard(value:bool):
	is_shard=value

func get_cooldown():
	return cooldown


func _on_timer_death_timeout():
	queue_free()
