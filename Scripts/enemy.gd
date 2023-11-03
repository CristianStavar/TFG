extends CharacterBody2D



@export var nombre:String
@export var health: int=5
@export var damage: int=10

@export var move_speed:float=50
@export var attack_range:float=22
@export var attack_cooldown:float=.4

@export var experience_token:PackedScene

var can_attack:=false
var lastAtackTime:float
var muerto:bool=false

var target: CharacterBody2D
var gameManager:Node2D
var agent:NavigationAgent2D
var sprite:Sprite2D
var audio:AudioStreamPlayer2D
var timer:Timer
var timer_attack_cooldown:Timer

var estadoDentro:=false

func _ready():
	agent=$NavigationAgent2D
	sprite=$Sprite
	timer=$Timer
	timer_attack_cooldown=$TimerAttackCooldown
	timer_attack_cooldown.set_wait_time(attack_cooldown)
#	audio=$Audio
	gameManager=get_node("/root/Main")
	target=gameManager.player
	add_to_group("Enemigo")


	
func _physics_process(_delta):
	if agent.is_navigation_finished():
#		print("NAvegacion finita")
		return
	var direction=self.position.direction_to(agent.get_next_path_position())
#	print("position global: "+str(self.position))
#	print("NExt path position: "+str(agent.get_next_path_position()))
#	print("La direction es: "+str(direction)+str(" Y movesped: ",moveSpeed))
	velocity=direction*move_speed # Velocity viene de CharacterBody2D
#	print("Mi velocity es :"+str(velocity))
#	print("Intento acercarme a player")
	move_and_slide()	#PAra aplicar la velocity al characterBody2D
	
	
func make_path():
	if target != null:
		agent.target_position=target.position
#		print("player esta en :"+str(agent.target_position))
#		print("Yo estoy en: "+str(self.position))
	


func _on_timer_timeout():
	make_path()
	
func quitar_vida(cantidad):
	health-=cantidad
	print("Me hicieron pupa: "+str(cantidad))
	sprite.modulate=Color.DARK_RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate=Color.WHITE

	if health<=0:
		print("he muerto: - "+str(self))
		spawn_experience_token()
		queue_free()
		
		

func spawn_experience_token():
	var b = experience_token.instantiate()
	
	b.global_position=self.global_position
	get_parent().add_child(b)



func set_vida(cantidad:int):
	health=cantidad



func _on_timer_attack_cooldown_timeout():
	can_attack=true
	start_attack_player()

func set_can_attack(value:bool):
	can_attack=value
	
func start_attack_player():
	if can_attack:
		target.take_damage(damage)
		timer_attack_cooldown.start()
	
func stop_attack_player():
	can_attack=false
	timer_attack_cooldown.stop()


func get_damage():
	return damage
