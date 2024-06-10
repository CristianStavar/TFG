extends "res://Scripts/enemy.gd"

var player_in_range:=false
@export var bullet:PackedScene

var hard_difficulty:=false


func _physics_process(_delta):
	if self.position.distance_to(target.position)> 100:
		var direction=self.position.direction_to(target.position)
		velocity=direction*move_speed # Velocity viene de CharacterBody2D
		move_and_slide()	#PAra aplicar la velocity al characterBody2D


func _on_area_2d_body_entered(_body):
	player_in_range=true
	$TimerShoot.start()


func _on_area_2d_body_exited(_body):
	player_in_range=false
	$TimerShoot.stop()


func _on_timer_shoot_timeout():
	if not hard_difficulty:
		shoot_bullet()
	else:
		shoot_two_bullets()

func shoot_bullet():
	var b = bullet.instantiate()	
	b.set_damage(damage)
	b.global_position=self.global_position
	b.define_direction( global_position.direction_to(target.position))
	get_parent().add_child(b)

func shoot_two_bullets():
		for angle in [-10,10]:
			var radians = deg_to_rad(angle)
			var b = bullet.instantiate()
			b.set_damage(damage)
			get_parent().add_child(b)
			b.direction = global_position.direction_to(target.position).rotated(radians)
			b.global_position = self.global_position
			b.define_direction(global_position.direction_to(target.position).rotated(radians))
		

func set_hard(value:bool):
	hard_difficulty=value
