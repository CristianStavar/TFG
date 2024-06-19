extends "res://Scripts/attack_dagger.gd"

var target:Node
var last_target_position:=Vector2(0,0)
var fragile_active:=false
@export var shard_image:=Texture2D
@onready var sprite:=$Sprite2D

@onready var gameManager:=get_node("/root/MainGame")
# Called when the node enters the scene tree for the first time.
func _ready():
	$TimerCooldown.set_wait_time(cooldown)
	self_attack=load("res://Ataques/Propios/attack_dagger.tscn")
	choose_target()

func _physics_process(delta):
	if target !=null:
		if is_instance_valid(target):
			last_target_position=target.global_position
			look_at(last_target_position)
		#		print("posicion antes: ++++"+str(position))
		#	global_position+= (direction * speed * delta)
			position=position.move_toward(last_target_position,speed*delta)
	else:
		look_at(last_target_position)
		position=position.move_toward(last_target_position,speed*delta)

func choose_target():
	target=gameManager.player.pick_random_nearby_enemy()
	

func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy"):
		body.substract_health(damage)
		SignalBus.damage_dealt.emit(damage,attack_name)
		
		if fragile_active:
			for i in 3:
				var angle=randi_range(0,360)
				var radians = deg_to_rad(angle)
				var bullet = self_attack.instantiate()
				
				bullet.define_direction( Vector2(1,0).rotated(radians))
				get_parent().add_child.call_deferred(bullet)
#				bullet.set_is_shard(true)
				bullet.update_damage(damage/2)
				if angle>=0 and angle<90:
					bullet.global_position = self.global_position+Vector2(20,10)
				elif angle>=90 and angle<180:
					bullet.global_position = self.global_position+Vector2(-20,10)
				elif angle>=180 and angle<270:
					bullet.global_position = self.global_position+Vector2(-20,-25)
				elif angle>=270 and angle<=360:
					bullet.global_position = self.global_position+Vector2(25,-20)
				

		
		queue_free()
	
	if body.is_in_group("Destroyable"):
		body.destroy_self()
		queue_free()


func set_is_shard(value:bool):
	is_shard=value
	if value:
#		sprite.texture=shard_image
		$Area2D.scale=Vector2(.6,.6)
