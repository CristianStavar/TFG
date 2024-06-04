extends "res://Scripts/enemy.gd"


var time:=0.0
var radius:=36.0
var speedRotation:=5.0


#func _physics_process(delta):
#	time+=delta
#	position=Vector2(sin(time*speedRotation)*radius,cos(time*speedRotation)*radius)


func _physics_process(_delta):

	var direction=self.position.direction_to(target.position)
	velocity=direction*move_speed # Velocity viene de CharacterBody2D
	move_and_slide()	#PAra aplicar la velocity al characterBody2D
#
