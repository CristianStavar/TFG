extends Node2D

var daño:float=2.0

var speed = 200
var direction

func _physics_process(delta):
	if direction!=null:
#		print("posicion antes: ++++"+str(position))
		global_position+= (direction * speed * delta)
#		print("Posicion despues--------- "+str(position," // Sumando: ",(direction * speed * delta)))

func _on_body_entered(body):
#	print("000000000000000000 He chocado en :" +str(self.global_position))
	if body.is_in_group("Player"):
		print("*-*-*-+++++++++++++++++++++++++++ CHOCO CON JUGADOR")
		body.quitar_vida(daño)		
		queue_free()
	print("/////////////////////////////////////////////////// He tocao algo, noseqes soy una bolita")

func define_direction(defined_direction):
#	print("0000000000000000000 He nacido en: "+str(self.global_position))
#	add_constant_central_force(direction)
	direction=defined_direction
	update_rotation()

func update_rotation():
	self.set_rotation(direction.angle()) 
	

func _on_timer_timeout():
#	print("-*-* MUERO POR TIEMPO")
	queue_free()
