extends "res://Scripts/enemy.gd"


var player_in_range:=false
@export var bullet:PackedScene

@export var bullet_speed:=200



func _physics_process(_delta):
#	if agent.is_navigation_finished():
#		return
#	var direction=self.position.direction_to(agent.get_next_path_position())
	if self.position.distance_to(target.position)> 150:
		var direction=self.position.direction_to(target.position)
		velocity=direction*move_speed # Velocity viene de CharacterBody2D
		move_and_slide()	#PAra aplicar la velocity al characterBody2D
	if self.position.distance_to(target.position)< 100:
		var direction=target.position.direction_to(self.position)
		velocity=direction*move_speed*1.5 # Velocity viene de CharacterBody2D
		move_and_slide()	#PAra aplicar la velocity al characterBody2D




func _on_area_2d_body_entered(_body):
	player_in_range=true
	$TimerShoot.start()


func _on_area_2d_body_exited(_body):
	player_in_range=false
	$TimerShoot.stop()


func _on_timer_shoot_timeout():
#	shoot_bullet()
	triple_shoot()

func shoot_bullet():
	var b = bullet.instantiate()	
	b.set_damage(damage)
	b.global_position=self.global_position
	b.define_direction( global_position.direction_to(target.position))
	get_parent().add_child(b)


func triple_shoot():
	for angle in [-15,15,0]:
		var radians = deg_to_rad(angle)
		var b = bullet.instantiate()
		b.set_damage(damage)
		b.set_speed(bullet_speed)
		owner.add_child(b)
		b.direction = global_position.direction_to(target.position).rotated(radians)
		b.global_position = self.global_position
		b.define_direction(global_position.direction_to(target.position).rotated(radians))
		
