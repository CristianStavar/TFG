extends Node2D

var damage:float=2.0

var speed = 200
var direction

func _physics_process(delta):
	if direction!=null:
		global_position+= (direction * speed * delta)


func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("*-*-*-+++++++++++++++++++++++++++ CHOCO CON JUGADOR")
		body.quitar_vida(damage)		
		queue_free()
	print("/////////////////////////////////////////////////// He tocao algo, noseqes soy una bolita")

func define_direction(defined_direction):
#	add_constant_central_force(direction)
	direction=defined_direction
	update_rotation()

func update_rotation():
	self.set_rotation(direction.angle()) 
	

func _on_timer_timeout():
#	print("-*-* MUERO POR TIEMPO")
	queue_free()
