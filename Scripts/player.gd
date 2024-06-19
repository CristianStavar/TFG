extends CharacterBody2D


@export_group("Player stats")

@export var move_speed := 300.0  # speed in pixels/sec
@export var max_health:=120.0
var health:=max_health
@export var lvl_up_extra_health:=4
@export var health_regeneration:=0.1
@export var extra_damage:=0.0
@export var experience_level_multiplier:=1.14

var experience_points:=0.0
var experience_points_to_level:=14.0
var current_level:=1


@export_group("")

@onready var game_manager:=get_node("/root/MainGame")



					#DAGGER
@export var attack_dagger:PackedScene
@export var dagger_cooldown:=1.2
@export var dagger_cooldown_min:=0.4
var dagger_upgrades: Array[float]=[0.0,0.0,0.0,1.0] # Damage,speed,coldoown reduction, quantity
var dagger_shotgun_mode:=false
var dagger_separation_mode:=false

					#SPEAR
var spear_gotten:=false
@export var attack_spear:PackedScene
@export var spear_cooldown:=3.0
@export var spear_cooldown_min:=0.9
var spear_upgrades:Array[float]=[0.0,0.0,3.0]#Damage,cdr,quantity

					#HAMMER
var hammer_gotten:=false
@export var attack_hammer:PackedScene
@export var hammer_cooldown:=2
@export var hammer_cooldown_min:=0.8
var hammer_upgrades:Array[float]=[0.0,0.0,0.0,1.0]#Damage,speed, cdr, quantity
var hammer_shatter_mode:=false

					#AXE TORNADO
var axe_tornado_gotten:=false
#@export var attack_axe_tornado:PackedScene
var attack_axe_tornado:=load("res://Ataques/Propios/TornadoHachas.tscn")
@export var axe_tornado_cooldown:=3.5
@export var axe_tornado_cooldown_min:=1.0
var axe_tornado_upgrades:Array[float]=[0.0,0.0,0.0,0.0,1.0]# Damage,size,duration,cdr, quantity
var axe_tornado_wild_mode:=false
var axe_tornado_moving_mode:=false

					#SHIELD
var shield_gotten:=false
@export var attack_orbital_shield:PackedScene
var orbital_shields_array:Array[Node2D]
var orbital_shield_upgrades:Array[float]=[0.0,0.0,1.0]# Damage, speed, quantity
var orbital_shield_block_mode:=false
var last_shield_quantity:=1
@export var max_shield_quantity:=4


var direction
var direction_shoot=Vector2(1,0)



var cooldownSkill1:=false
var cooldownHoming1:=false


@export var nearby_enemies:=[]




var aim_direction:Vector2

var shotgun_bullets:=8





var cooldown_press:=false


@onready var timer_dagger:=get_node("TimerDagger")
@onready var timer_spear:=get_node("TimerSpear")
@onready var timer_hammer:=get_node("TimerHammer")
@onready var timer_axe_tornado:=get_node("TimerAxeTornado")


@onready var health_bar:=get_node("HealthBar")
@onready var experience_bar:=get_node("ExperienceProgressBar"	)




@export_group("Unlockable Cards")
@export var unlockable_dagger_shotgun:=CardSkill
@export var unlockable_dagger_separation:=CardSkill
@export var unlockable_axe_tornado:=CardSkill
var axe_tornado_time_passed:=false
@export var unlockable_orbital_shield:=CardSkill
var shield_time_passed:=false
@export var unlockable_orbital_shield_solid:=CardSkill
@export var unlockable_hammer_fragile:=CardSkill



@onready var sound_shoot = $Sounds/SoundShoot
@onready var sound_shotgun = $Sounds/SoundShotgun
@onready var sound_heal = $Sounds/SoundHeal
@onready var sound_level_up = $Sounds/SoundLevelUp




#checks
var only_dagger:=true

var in_touchscreen:=false

@onready var aim_aid:=$AimPoint


var player_alive:=true

func _ready():
	SignalBus.connect("card_chosen",skill_card_chosen)
	SignalBus.connect("ask_for_only_dagger",send_only_dagger)
	game_manager.player=self
	add_to_group("Player")
	health_bar.max_value=max_health
	health_bar.value=max_health
	health=max_health
	
	experience_bar.max_value=experience_points_to_level
	experience_bar.value=0
	in_touchscreen=touchscreen_check()


func _physics_process(_delta):
	aim_direction = global_position.direction_to(get_global_mouse_position())
	
	if not in_touchscreen:
		direction = Input.get_vector("left", "right", "up", "down")
		velocity = direction * move_speed
		if direction!=Vector2(0,0):
			direction_shoot=direction
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and in_touchscreen:
		direction=global_position.direction_to(get_global_mouse_position())
		velocity = direction * move_speed
		if direction!=Vector2(0,0):
			direction_shoot=direction
	aim_aid.look_at(global_position+direction_shoot)
	move_and_slide()
	



func touchscreen_check():
	var check=JavaScriptBridge.eval("""
	"ontouchstart" in document.documentElement
	""")
	#DEVUELVE 0 en PC
	if check>0:  
		return true
	else:
		return false
		





"""
##        ########  ##     ##  ########  ##                ##     ##  ########  
##        ##        ##     ##  ##        ##                ##     ##  ##     ## 
##        ##        ##     ##  ##        ##                ##     ##  ##     ## 
##        ######    ##     ##  ######    ##                ##     ##  ########  
##        ##         ##   ##   ##        ##                ##     ##  ##        
##        ##          ## ##    ##        ##                ##     ##  ##        
########  ########     ###     ########  ########           #######   ##        
"""


func add_experience(quantity:float):
	experience_points+=quantity
	experience_bar.value=experience_points
	if experience_points>=experience_points_to_level:
		player_level_up()
	game_manager.update_player_ui()

func player_level_up():
	current_level+=1
	max_health+=lvl_up_extra_health
	health+=lvl_up_extra_health
	experience_points=experience_points-experience_points_to_level
	experience_bar.value=experience_points
	update_experience_to_level_up()
	SignalBus.player_level_up.emit(current_level)



func update_experience_to_level_up():
	experience_points_to_level*=experience_level_multiplier
	experience_bar.max_value=experience_points_to_level




func skill_card_chosen(skill:CardSkill):
	
	if skill.get_type()=="Attack":
		# Comparar los ataques y activar los timers?
		print("ES UN ATAQUE")
		match skill.attack:
			
			attack_spear:
				only_dagger=false
				spear_gotten=true
				timer_spear.start()
			attack_hammer:
				only_dagger=false
				hammer_gotten=true
				timer_hammer.start()
			attack_axe_tornado:
				only_dagger=false
				axe_tornado_gotten=true
				timer_axe_tornado.start()
			attack_orbital_shield:
				only_dagger=false
				shield_gotten=true
				spawn_shield_orbital()
	
	
	elif skill.get_type()=="Upgrade":
		if skill.player_upgrade:
			max_health+=skill.player_health_value
			health_regeneration+=skill.player_health_regen_value
			extra_damage+=skill.player_extra_damage_value
			move_speed+=skill.player_move_speed_value
		elif skill.dagger_upgrade:
			dagger_upgrades[0]+=skill.dagger_damage_value
			dagger_upgrades[1]+=skill.dagger_speed_value
			dagger_upgrades[2]+=skill.dagger_cooldown_value
			dagger_upgrades[3]+=skill.dagger_extra_dagger_value
			if skill.dagger_shotgun_upgrade:
				dagger_shotgun_mode=skill.dagger_shotgun_upgrade
			if skill.dagger_separation_upgrade:
				dagger_separation_mode=skill.dagger_separation_upgrade
		elif skill.axe_tornado_upgrade:
			axe_tornado_upgrades[0]+=skill.axe_tornado_damage_value
			axe_tornado_upgrades[1]+=skill.axe_tornado_size_value
			axe_tornado_upgrades[2]+=skill.axe_tornado_duration_value
			axe_tornado_upgrades[3]+=skill.axe_tornado_cooldown_value
			axe_tornado_upgrades[4]+=skill.axe_tornado_extra_tornado_value
		elif skill.spear_upgrade:
			spear_upgrades[0]+=skill.spear_damage_value
			spear_upgrades[1]+=skill.spear_cooldown_value
			spear_upgrades[2]+=skill.spear_extra_spear_value
		elif skill.hammer_upgrade:
			hammer_upgrades[0]+=skill.hammer_damage_value
			hammer_upgrades[1]+=skill.hammer_speed_value
			hammer_upgrades[2]+=skill.hammer_cooldown_value
			hammer_upgrades[3]+=skill.hammer_extra_hammer_value
			if skill.hammer_fragile_upgrade:
				hammer_shatter_mode=skill.hammer_fragile_upgrade
		elif skill.shield_upgrade:
			orbital_shield_upgrades[0]+=skill.shield_damage_value
			orbital_shield_upgrades[1]+=skill.shield_speed_value
			if orbital_shield_upgrades[2]< max_shield_quantity:
				orbital_shield_upgrades[2]+=skill.shield_extra_shield_value
			elif orbital_shield_upgrades[2]< max_shield_quantity:
				SignalBus.lock_maxed_card.emit("Shield")
			if skill.shield_solid_shield:
				orbital_shield_block_mode=true
				make_solid_shields()
			check_extra_shield()
		check_for_new_upgrades()
	else:
		print("Error, el tipo no es correcto: "+str(skill.get_type()))
	
	update_attacks_timers()



func check_for_new_upgrades():
	if dagger_upgrades[3]>2:
		SignalBus.card_unlocked_condition.emit("Daga Escopeta","Upgrade")
		#SignalBus.card_unlocked.emit(unlockable_dagger_shotgun)
		
	if game_manager.get_time_passed()>=500:
		SignalBus.card_unlocked_condition.emit("Abanico de dagas","Upgrade")
		#SignalBus.card_unlocked.emit(unlockable_dagger_separation)
		
	if shield_time_passed: # Tiempo de partida pasado escudo
		SignalBus.card_unlocked_condition.emit("Escudo orbital","Attack")
		#SignalBus.card_unlocked.emit(unlockable_orbital_shield)
		
	if orbital_shield_upgrades[2]>=3:
		SignalBus.card_unlocked_condition.emit("Escudo solido","Upgrade")
		#SignalBus.card_unlocked.emit(unlockable_orbital_shield_solid)
		
	if axe_tornado_time_passed:   # Tiempo para tornado
		SignalBus.card_unlocked_condition.emit("Tormenta de hachas","Attack")
		#SignalBus.card_unlocked.emit(unlockable_axe_tornado)
		
	if hammer_upgrades[0]>3:
		SignalBus.card_unlocked_condition.emit("Martillo frágil","Upgrade")
		#SignalBus.card_unlocked.emit(unlockable_hammer_fragile)






func update_attacks_timers():
	
	var dagger_cdr_tmp:=dagger_cooldown- dagger_upgrades[2]
	if dagger_cdr_tmp>=dagger_cooldown_min:
		timer_dagger.set_wait_time(dagger_cooldown - dagger_upgrades[2])
	else:
		timer_dagger.set_wait_time(dagger_cooldown_min)
		SignalBus.lock_maxed_card.emit("Dagger")
		

	var spear_cdr_tmp:=spear_cooldown - spear_upgrades[1]
	if spear_cdr_tmp>spear_cooldown_min:
		timer_spear.set_wait_time(spear_cooldown - spear_upgrades[1])
	else:
		timer_spear.set_wait_time(spear_cooldown_min)
		SignalBus.lock_maxed_card.emit("Spear")

	var hammer_cdr_tmp:=hammer_cooldown - hammer_upgrades[2]
	if hammer_cdr_tmp>hammer_cooldown_min:
		timer_hammer.set_wait_time(hammer_cooldown - hammer_upgrades[2])
	else:
		timer_hammer.set_wait_time(hammer_cooldown_min)
		SignalBus.lock_maxed_card.emit("Hammer")

	var axe_tornado_cdr_tmp:=axe_tornado_cooldown - axe_tornado_upgrades[2]
	if axe_tornado_cdr_tmp>axe_tornado_cooldown_min:
		timer_axe_tornado.set_wait_time(axe_tornado_cooldown - axe_tornado_upgrades[2])
	else:
		timer_axe_tornado.set_wait_time(axe_tornado_cooldown_min)	
		SignalBus.lock_maxed_card.emit("AxeStorm")







#####################################################################
#######################                        ######################
#######################     ATTACK SPAWNERS    ######################
#####################################################################



func shoot_dagger():
	sound_shoot.play()
	var b = attack_dagger.instantiate()
	if dagger_separation_mode:
		b.set_separation(dagger_separation_mode)
		
	b.update_damage(dagger_upgrades[0]+extra_damage)
	b.update_speed(dagger_upgrades[1])
	owner.add_child(b)
	b.transform = $Muzzle.transform
	b.global_position=$Muzzle.global_position
	b.define_direction(direction_shoot)

func dagger_shotgun2():
	sound_shotgun.play()
	var last_angle:=0.0
	var angle:=0.0
	for i in range(dagger_upgrades.back()):
		var radians = deg_to_rad(angle)
		last_angle=angle
		var bullet = attack_dagger.instantiate()
		if dagger_separation_mode:
			bullet.set_separation(dagger_separation_mode)
		
		bullet.update_damage(dagger_upgrades[0]+extra_damage)
		bullet.update_speed(dagger_upgrades[1])
		bullet.direction = direction_shoot.rotated(radians)
		bullet.global_position = self.global_position
		bullet.update_rotation()
		owner.add_child(bullet)
		
		angle = randf_range(-10, 10)
		while abs(angle - last_angle) < 3:
			angle = randf_range(-10, 10)
		await get_tree().create_timer(0.01).timeout




func throw_hammer():
	if pick_random_nearby_enemy!=null:
		sound_shoot.play()
		var b = attack_hammer.instantiate()
		b.update_damage(hammer_upgrades[0]+extra_damage)
		b.update_speed(hammer_upgrades[1])
		b.fragile_active=hammer_shatter_mode
		owner.add_child(b)
		b.transform = $Muzzle.transform
		b.global_position=$Muzzle.global_position




func throw_spear():
	sound_shoot.play()
	var point=randv_circle()+self.position
	var b = attack_spear.instantiate()
	
	b.update_damage(spear_upgrades[0]+extra_damage)
	owner.add_child(b)
	b.transform = $Muzzle.transform
	b.global_position=$Muzzle.global_position
	b.define_direction(global_position.direction_to(point))
	await get_tree().create_timer(0.05).timeout




func spawn_axe_tornado():
	var b = attack_axe_tornado.instantiate()
		
	owner.add_child(b)
	var enemy_target=pick_random_nearby_enemy()
	if enemy_target!=null:
		b.position = enemy_target.position
		b.update_damage(axe_tornado_upgrades[0]+extra_damage)
		b.increase_size(axe_tornado_upgrades[1])
		b.update_duration(axe_tornado_upgrades[2])
	else:
		b.queue_free()



func spawn_shield_orbital():
	var shield = attack_orbital_shield.instantiate()


	add_child(shield)
	shield.update_damage(orbital_shield_upgrades[0]+extra_damage)
	shield.update_rotation_speed(orbital_shield_upgrades[1])
	orbital_shield_upgrades[1]+=.2
	orbital_shields_array.append(shield)
	if orbital_shield_block_mode:
		make_solid_shields()


func check_extra_shield():
	if orbital_shields_array.size() != orbital_shield_upgrades[2]:

		print(" Añadimos escudo sisi y tenemos: "+str(orbital_shields_array.size()))
		spawn_shield_orbital()


func make_solid_shields():
	for shield in orbital_shields_array:
		shield.activate_solid_shield()





func StarShot():
	for angle in [-45,-90,-135,-190,135,90,45,0]:
		print("-------------"+str(angle))
		var radians = deg_to_rad(angle)
		var bullet = attack_dagger.instantiate()
		owner.add_child(bullet)
		bullet.direction = aim_direction.rotated(radians)
		bullet.global_position = self.global_position
		bullet.define_direction(aim_direction.rotated(radians))
		


#####################################################################
#######################                        ######################
#######################     ATTACKS TIMERS     ######################
#####################################################################


func _on_timer_dagger_timeout():
	if dagger_shotgun_mode:
		dagger_shotgun2()
	else:
		for i in range(dagger_upgrades.back()):
			shoot_dagger()
			await get_tree().create_timer(0.09).timeout



func _on_timer_spear_timeout():
	for i in range(spear_upgrades.back()):
		throw_spear()
		



func _on_timer_tornado_timeout():
	cooldownSkill1=false
	for i in range(axe_tornado_upgrades.back()):
		spawn_axe_tornado()
		await get_tree().create_timer(0.02).timeout

func _on_timer_hammer_timeout():
	cooldownHoming1=false
	for i in range(hammer_upgrades.back()):
		throw_hammer()
		await get_tree().create_timer(0.08).timeout









func heal_player(value):
	sound_heal.play()
	health+=value
	if health>max_health:
		health=max_health
#	game_manager.update_health(health)



func regenerate():
	health+=health_regeneration
	health_bar.value=health
#	game_manager.update_health(health)





func take_damage(value:float):
	if  player_alive:
		health-=value
		SignalBus.player_take_damage.emit(value)
#	game_manager.update_health(health)
	health_bar.value=health
	
	if health <=0:
		player_alive=false
		health=0
		player_died()



func player_died():
	SignalBus.player_died.emit()
	
	

func send_only_dagger():
	SignalBus.send_only_dagger.emit(only_dagger)

""" 

##     ##  ########  ####  ##        ####  ########  ####  ########   ######  
##     ##     ##      ##   ##         ##      ##      ##   ##        ##    ## 
##     ##     ##      ##   ##         ##      ##      ##   ##        ##       
##     ##     ##      ##   ##         ##      ##      ##   ######     ######  
##     ##     ##      ##   ##         ##      ##      ##   ##              ## 
##     ##     ##      ##   ##         ##      ##      ##   ##        ##    ## 
 #######      ##     ####  ########  ####     ##     ####  ########   ######  


"""


func pick_random_nearby_enemy():
	if nearby_enemies.size()<=0:
		return null
	return nearby_enemies.pick_random()


func randv_circle(min_radius := 200.0, max_radius := 300.0) -> Vector2:
	var r2_max := max_radius * max_radius
	var r2_min := min_radius * min_radius
	var r := sqrt(randf() * (r2_max - r2_min) + r2_min)
	var t := randf() * TAU
	return Vector2(r, 0).rotated(t)









func _on_nearby_area_body_entered(body):
	nearby_enemies.append(body)


func _on_nearby_area_body_exited(body):
	nearby_enemies.erase(body)


func _on_timer_pulsador_timeout():
	cooldown_press=false


func _on_area_damage_body_entered(body):
	if body.is_in_group("Enemy"):
		body.set_can_attack(true)
		body.start_attack_player()


func _on_area_damage_body_exited(body):
	if body.is_in_group("Enemy"):
		body.stop_attack_player()


func _on_area_kill_body_exited(body):
	if body.is_in_group("Enemy") and not body.is_in_group("Boss"):
		body.queue_free()
