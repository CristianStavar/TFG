extends "res://Scripts/enemy.gd"

var player_in_range:=false
@export var bullet:PackedScene


func _on_area_2d_body_entered(_body):
	player_in_range=true
	$TimerShoot.start()


func _on_area_2d_body_exited(_body):
	player_in_range=false
	$TimerShoot.stop()


func _on_timer_shoot_timeout():
	shoot_bullet()

func shoot_bullet():
	var b = bullet.instantiate()	
	b.set_damage(damage)
	b.global_position=self.global_position
	b.define_direction( global_position.direction_to(target.position))
	get_parent().add_child(b)

