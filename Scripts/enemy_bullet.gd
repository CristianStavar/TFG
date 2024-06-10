extends Node2D

var damage:float=2.0

var speed = 100
var direction

func _ready():
	add_to_group("EnemyBullet")

func _physics_process(delta):
	if direction!=null:
		global_position+= (direction * speed * delta)


func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(damage)		
		queue_free()
	
	
	
func define_direction(defined_direction):
#	add_constant_central_force(direction)
	direction=defined_direction
	update_rotation()

func self_destruct():
	queue_free()

func update_rotation():
	self.set_rotation(direction.angle()) 
	

func _on_timer_timeout():
#	print("-*-* MUERO POR TIEMPO")
	queue_free()

func set_damage(value:float):
	damage=value


func set_speed(value:float):
	speed=value


	
