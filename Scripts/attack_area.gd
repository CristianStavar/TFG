extends Node

@export var attack_name:String
@export var damage:float=1.0

var speed = 800
var direction

@export var cooldown:=4.5
@export var duration:=1.5
@export var area_group_name:=""
@export var cooldown_damage:=0.4

@export var wild_tornado:=false

@onready var timer_duration:=get_node("TimerDuration")

@onready var particles:=get_node("GPUParticles2D")
@onready var collision_area:=get_node("Area2D")

var bodies_inside:Array
var size_scale:=1.0
var axes_ammount:int
var last_axe_addition:=2
@export var threshold_add_axes:=0.15


@export var show_name:String
@export_multiline var description:String
@export_multiline var unique_upgrades:String

# Called when the node enters the scene tree for the first time.
func _ready():
	$"TimerDamage".set_wait_time(cooldown_damage)
	timer_duration.set_wait_time(duration)
	axes_ammount=particles.get_amount()



func increase_size(value:float):
	size_scale+=value
	collision_area.set_scale(collision_area.get_scale()*size_scale)
	particles.set_scale(particles.get_scale()*size_scale)
	add_extra_axe_particles()
	
	"Cambiar escala de la collision shape añadiendo el porcentaje float
	Cambiar escala del nodoparticulas para que sea más amplio. Se mantiene el tamaño individual de hachas
	Cada x porcentaje de aumento de tamaño incrementar el numero de hachas para que no quede vacio."


func add_extra_axe_particles():
	var tmp_nr_axes=floor(size_scale/threshold_add_axes)
	axes_ammount=tmp_nr_axes-last_axe_addition
	last_axe_addition=tmp_nr_axes
	particles.set_amount(axes_ammount)



func update_damage(value:float):
	damage+=value


func update_duration(value:float):
	duration+=value
	timer_duration.set_wait_time(duration)




func damage_enemies_inside():
	if bodies_inside.size()>0:
		for i in bodies_inside.size():
			bodies_inside[i].substract_health(damage)
			SignalBus.damage_dealt.emit(damage,attack_name)
	
	if wild_tornado:
		pass


func _on_body_exited(body):
	if body.is_in_group("Enemy"):
		bodies_inside.erase(body)
		body.remove_from_group(area_group_name)


func _on_body_entered(body):
	if body.is_in_group("Enemy")and not body.is_in_group(area_group_name):
		bodies_inside.append(body)
		body.add_to_group(area_group_name)
		body.substract_health(damage)



func _on_timer_duration_timeout():
	queue_free()


func _on_timer_damage_timeout():
	damage_enemies_inside()
