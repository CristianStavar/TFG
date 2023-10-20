extends CharacterBody2D


@onready var game_manager:=get_node("/root/Main")

@export var attack_dagger:PackedScene
var proyectilesDaga:=3

var speed = 300  # speed in pixels/sec
var direction
var direction_shoot=Vector2(1,0)

func _physics_process(delta):
	
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if direction!=Vector2(0,0):
		direction_shoot=direction

	move_and_slide()


func shoot_dagger():
	var b = attack_dagger.instantiate()
	owner.add_child(b)
	b.transform = $Muzzle.transform
	b.global_position=$Muzzle.global_position
	b.define_direction(direction_shoot)


func _on_timer_dagger_timeout():
	for i in range(proyectilesDaga):
		shoot_dagger()
		await get_tree().create_timer(0.08).timeout
