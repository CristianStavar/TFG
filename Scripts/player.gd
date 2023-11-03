extends CharacterBody2D


@onready var game_manager:=get_node("/root/Main")

@export var attack_dagger:PackedScene
var proyectilesDaga:=3

var speed = 300  # speed in pixels/sec
var direction
var direction_shoot=Vector2(1,0)



@export var tornado:PackedScene

@onready var orbital1:=get_node("Orbital")

@export var homing:PackedScene

var cooldownSkill1:=false
var cooldownHoming1:=false


var enemigosCerca:=[]


var puntosExperiencia:=0.0
var puntosExperienciaSubir:=14
var nivelActual:=1


var aim_direction:Vector2

var shotgun_bullets:=8


var escopetaActiva:=false
var separacionActiva:=false
var estrellaActiva:=false

var cooldown_press:=false



var health:=0.0


@export var experience_level_multiplier:=1.2

func _ready():
	game_manager.player=self
	add_to_group("Player")

func _physics_process(_delta):
	game_manager.update_position(self.global_position)
	aim_direction = global_position.direction_to(get_global_mouse_position())
	
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if direction!=Vector2(0,0):
		direction_shoot=direction

	move_and_slide()
	
	
	if Input.is_action_pressed("cambioescopeta") and not cooldown_press:
		cooldown_press=true
		$TimerPulsador.start()
		escopetaActiva= not escopetaActiva
		print("PASAMOS ESCOPETA A: "+str(escopetaActiva))
		game_manager.ActivarEstadoArma("Escopeta",escopetaActiva)
		
	if Input.is_action_pressed("cambioseparacion") and not cooldown_press:
		cooldown_press=true
		$TimerPulsador.start()
		separacionActiva= not separacionActiva
		print("PASAMOS separacionActiva A: "+str(separacionActiva))
		game_manager.ActivarEstadoArma("Separacion",separacionActiva)
	
	if Input.is_action_pressed("cambioestrella") and not cooldown_press:
		cooldown_press=true
		$TimerPulsador.start()
		estrellaActiva= not estrellaActiva
		print("PASAMOS separacionActiva A: "+str(estrellaActiva))
		game_manager.ActivarEstadoArma("Estrella",estrellaActiva)
	
	
	if Input.is_action_pressed("action") and not cooldownSkill1:
		cooldownSkill1=true
		$TimerTornado.start()
		TORNADOO()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and not cooldownHoming1:
		cooldownHoming1=true
		$TimerHoming.start()
		Homing()
		
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not cooldownHoming1 and not escopetaActiva and not estrellaActiva:
		cooldownHoming1=true
		$TimerHoming.start()
		Pistol()
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not cooldownHoming1 and escopetaActiva and not estrellaActiva:
		cooldownHoming1=true
		$TimerHoming.start()
		Shotgun()
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not cooldownHoming1 and not escopetaActiva and estrellaActiva:
		cooldownHoming1=true
		$TimerHoming.start()
		StarShot()


func shoot_dagger():
	var b = attack_dagger.instantiate()
	if separacionActiva:
		b.set_separation(separacionActiva)
		
	owner.add_child(b)
	b.transform = $Muzzle.transform
	b.global_position=$Muzzle.global_position
	b.define_direction(direction_shoot)




func TORNADOO():
	var b = tornado.instantiate()
	owner.add_child(b)
	b.position = get_global_mouse_position()
	
	
func Homing():
	var b = homing.instantiate()
	owner.add_child(b)
	b.transform = $Muzzle.transform
	b.global_position=$Muzzle.global_position
	
	
func Shotgun():
	var last_angle:=0.0
	var angle:=0.0
	for i in range(shotgun_bullets):
		var radians = deg_to_rad(angle)
		last_angle=angle
		var bullet = attack_dagger.instantiate()
		bullet.direction = aim_direction.rotated(radians)
		bullet.global_position = self.global_position
		bullet.update_rotation()
		owner.add_child(bullet)
		
		angle = randf_range(-15, 15)
		while abs(angle - last_angle) < 12:
			angle = randf_range(-15, 15)



func add_experience(quantity:float):
	puntosExperiencia+=quantity
	if puntosExperiencia>=puntosExperienciaSubir:
		player_level_up()
	game_manager.update_player_ui()

func player_level_up():
	nivelActual+=1
	puntosExperiencia=puntosExperiencia-puntosExperienciaSubir
	update_experience_to_level_up()
	game_manager.show_player_level_up()
	

func update_experience_to_level_up():
	puntosExperienciaSubir*=experience_level_multiplier


func Pistol():
	var b = attack_dagger.instantiate()
	if separacionActiva:
		b.set_separation(separacionActiva)
		
	owner.add_child(b)
	b.transform = $Muzzle.transform
	b.global_position=$Muzzle.global_position
	b.define_direction(aim_direction)
	

func StarShot():
	for angle in [-45,-90,-135,-190,135,90,45,0]:
		print("-------------"+str(angle))
		var radians = deg_to_rad(angle)
		var bullet = attack_dagger.instantiate()
		owner.add_child(bullet)
		bullet.direction = aim_direction.rotated(radians)
		bullet.global_position = self.global_position
		bullet.define_direction(aim_direction.rotated(radians))
		







func pick_random_nearby_enemy():
	return enemigosCerca.pick_random()


func take_damage(value:float):
	health-=value
	game_manager.update_health(health)
	print("*************** Dañaron al player: "+str(value))



func _on_timer_dagger_timeout():
	for i in range(proyectilesDaga):
		shoot_dagger()
		await get_tree().create_timer(0.08).timeout


func _on_timer_tornado_timeout():
	cooldownSkill1=false


func _on_timer_homing_timeout():
	cooldownHoming1=false




func _on_nearby_area_body_entered(body):
	enemigosCerca.append(body)


func _on_nearby_area_body_exited(body):
	enemigosCerca.erase(body)


func _on_timer_pulsador_timeout():
	cooldown_press=false


func _on_area_damage_body_entered(body):
	if body.is_in_group("Enemigo"):
		body.set_can_attack(true)
		body.start_attack_player()


func _on_area_damage_body_exited(body):
	if body.is_in_group("Enemigo"):
		body.stop_attack_player()
