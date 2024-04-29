extends CharacterBody2D

@export var tier:=0
@export var enemy_name:String
@export var health: int=5
@export var damage: int=10

@export var move_speed:float=50
@export var attack_range:float=22
@export var attack_cooldown:float=.4

@export var current_level:=0
@export var lvl_upgrades: Array[int]=[4,2] #health, damage

@export var experience_token:PackedScene

var can_attack:=false
var last_attack_time:float
var dead:bool=false

var target: CharacterBody2D
var gameManager:Node2D
var agent:NavigationAgent2D
var sprite:Sprite2D
var audio:AudioStreamPlayer2D
var timer:Timer
var timer_attack_cooldown:Timer

var estadoDentro:=false


var target_direction

func _ready():
	agent=$NavigationAgent2D
	sprite=$Sprite
	timer=$Timer
	timer_attack_cooldown=$TimerAttackCooldown
	timer_attack_cooldown.set_wait_time(attack_cooldown)
#	audio=$Audio
	gameManager=get_node("/root/MainGame")
	target=gameManager.player
	add_to_group("Enemy")
	

	
func _physics_process(_delta):
#	if agent.is_navigation_finished():
#		return
#	var direction=self.position.direction_to(agent.get_next_path_position())
	var direction=self.position.direction_to(target.position)
	velocity=direction*move_speed # Velocity viene de CharacterBody2D
	move_and_slide()	#PAra aplicar la velocity al characterBody2D
#
	
func make_path():
	if target != null:
		agent.target_position=target.position
#		target_direction=self.position.direction_to(agent.get_next_path_position())


func set_level(new_level:int):
	current_level=new_level
	health+=current_level*lvl_upgrades[0]
	damage+=current_level*lvl_upgrades[1]


func substract_health(value):
	health-=value
#	print("Me hicieron pupa: "+str(value))
	sprite.modulate=Color.DARK_RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate=Color.WHITE

	if health<=0:
		print("he muerto: - "+str(self))
		spawn_experience_token()
		SignalBus.enemy_killed.emit(enemy_name)
		queue_free()
		

func spawn_experience_token():
	var b = experience_token.instantiate()
	b.update_experience(tier,current_level)
	
	b.global_position=self.global_position
	get_parent().add_child(b)



func start_attack_player():
	if can_attack:
		target.take_damage(damage)
		timer_attack_cooldown.start()
	
func stop_attack_player():
	can_attack=false
	timer_attack_cooldown.stop()

##################################
################# GETTER / SETTER
##################################

func set_can_attack(value:bool):
	can_attack=value

func set_health(value:int):
	health=value

func get_damage():
	return damage

##################################
################# TIMERS
##################################

func _on_timer_timeout():
	make_path()


func _on_timer_attack_cooldown_timeout():
	can_attack=true
	start_attack_player()
