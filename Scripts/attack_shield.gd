extends Node2D

@export var attack_name:String
@export var damage:float=2.0


@export var cooldown:=1.0
@export var solid_shield:=false


var time:=0.0
var radius:=36.0
var speedRotation:=5.0


@export var show_name:String
@export_multiline var description:String
@export_multiline var unique_upgrades:String

func _ready():
#	$TimerCooldown.set_wait_time(cooldown)
	add_to_group("Orbital")


func _physics_process(delta):
	time+=delta
	position=Vector2(sin(time*speedRotation)*radius,cos(time*speedRotation)*radius)



func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		body.substract_health(damage)
		SignalBus.damage_dealt.emit(damage,attack_name)

	if body.is_in_group("Destroyable"):
		body.destroy_self()
		
	


func activate_solid_shield():
	solid_shield=true


	
func ActualizarTimerCooldown(valor:float):
	$TimerCooldown.set_wait_time(valor)

func ActualizarTimerDuracion(valor:float):
	$TimerDuracion.set_wait_time(valor)

func AumentaTamaño(valor:float):
	self.set_scale(get_scale()*valor)

	pass


func update_damage(value:float):
	damage+=value

func update_rotation_speed(value:float):
	speedRotation+=value


func _on_area_2d_area_entered(area):
	if solid_shield and area.get_parent().is_in_group("EnemyBullet"):
		SignalBus.projectile_blocked.emit()
		area.get_parent().self_destruct()
		
