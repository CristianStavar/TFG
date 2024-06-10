extends "res://Scripts/enemy.gd"


var player_in_range:=false
@export var bullet:PackedScene

@export var bullet_speed:=180


func _ready():
	agent=$NavigationAgent2D
	sprite=$Sprite
	timer=$Timer
	timer_attack_cooldown=$TimerAttackCooldown
	timer_attack_cooldown.set_wait_time(attack_cooldown)
	audio_hit=$AudioStreamPlayer2D
	gameManager=get_node("/root/MainGame")
	target=gameManager.player
	add_to_group("Enemy")
	add_to_group("Boss")
	


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
		velocity=direction*move_speed*1.2 # Velocity viene de CharacterBody2D
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
		get_parent().add_child(b)
		b.direction = global_position.direction_to(target.position).rotated(radians)
		b.global_position = self.global_position
		b.define_direction(global_position.direction_to(target.position).rotated(radians))
		




func _on_timer_star_shoot_timeout():
	for i in 2:
		await get_tree().create_timer(.8).timeout
		for angle in [-45,-90,-135,-190,135,90,45,0]:
			var radians = deg_to_rad(angle)
			var b = bullet.instantiate()
			b.set_damage(damage)
			b.set_speed(bullet_speed)
			get_parent().add_child(b)
			b.direction = global_position.direction_to(target.position).rotated(radians)
			b.global_position = self.global_position
			b.define_direction(global_position.direction_to(target.position).rotated(radians))
