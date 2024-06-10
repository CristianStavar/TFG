extends Node2D

""" 
	Timer interval upgrades para subir de nivel los enemigos. 
	Tener distintos tiers de enemigos, que no todos suban al mismo ritmo pero usare solo 1 timer 
y multiples variables una por tier?
	Timer boss, para cuando salga el boss
	TimerEnemy tier para la activacion de spawn de enemigos superiores.
	Pensar en como hacer que spawneen distitnos bichos de distinto tier y que con el tiempo 
sean menos frecuentes los masbajos.
"""

@export var current_lvl_enemy:=1
@export var current_tier_enemy:=0

@export var enemy_rat:PackedScene
@export var enemigo_fantasma:PackedScene

@export var tier1_enemies:Array[PackedScene]
@export var tier2_enemies:Array[PackedScene]
@export var tier3_enemies:Array[PackedScene]

@export var boss:PackedScene

#Array de enemigos por tier.
#Tier 0 SOLO u tipo, ratas
#Tier 1 normales, fantasmas y alguna cosa mas
#Tier 2 algo mas potente
#Tier 3 Bicharacos que salgan poco pero den bien de XP

@onready var game_manager:=$"/root/MainGame"   #Node2D
@onready var tile_map:=$"../MapGenerator/TileMap"


@export var interval_enemy_level_up_value:=0.0 # Enemy lvlup
@export var timer_enemy_tier_value:=0.0
@export var timer_spawn_value:=1.2

@export var wave_enemy_quantity:=0
@export var wave_enemy_frecuency:=0.0

@export var timer_boss_value:=500
var boss_spawned:=false



func _ready():
#	game_manager=get_parent()
	$IntervalEnemyLevelUp.set_wait_time(interval_enemy_level_up_value)
	$IntervalEnemyLevelUp.start()
	$TimerEnemyTier.set_wait_time(timer_enemy_tier_value)
	$TimerEnemyTier.start()
	$TimerSpawn.set_wait_time(timer_spawn_value)
	$TimerSpawn.start()
	$TimerSpawnWave.set_wait_time(wave_enemy_frecuency)
	$TimerSpawnWave.start()
	$TimerBoss.set_wait_time(timer_boss_value)
	$TimerBoss.start()
	
	
	
	enemy_rat=preload("res://Unidades/Enemigos/T0/enemy_rat.tscn")
	



func _on_timer_timeout():
	spawn_enemy("Rata")

func spawn_enemy(type:String):
	match type:
		"Rata":
			instantiate_specific_enemy(enemy_rat)
		"Fantasma":
			instantiate_specific_enemy(enemigo_fantasma)


func spawn_random_enemy_tier(tier:int):
	match tier:
		0:
			spawn_enemy("Rata")
		1:
			instantiate_enemy_tier(tier1_enemies)
		2:
			instantiate_enemy_tier(tier2_enemies)
		3:
			instantiate_enemy_tier(tier3_enemies)


func instantiate_enemy_tier(tier:Array):
	var enemy_position:Vector2=randv_circle()
	var tile=tile_map.get_cell_atlas_coords(1,tile_map.local_to_map(enemy_position+game_manager.player.global_position))
#	print("\n\n +++++++++\nNo se que imprime esto vamos a verlo:    "+str(tile))
	if tile==Vector2i(3,0) or tile==Vector2i(4,0):
		instantiate_enemy_tier(tier)
	
	else:
		var enemy = tier.pick_random().instantiate()
		enemy.set_level(current_lvl_enemy)
		enemy.global_position=enemy_position+game_manager.player.global_position
		game_manager.add_child(enemy)
	
	
func instantiate_specific_enemy(specific_enemy:PackedScene):
	var enemy_position:Vector2=randv_circle()
	
	var tile=tile_map.get_cell_atlas_coords(1,tile_map.local_to_map(enemy_position+game_manager.player.global_position))
#	print("\n\n +++++++++\nNo se que imprime esto vamos a verlo:    "+str(tile))
	if tile==Vector2i(3,0) or tile==Vector2i(4,0):
		instantiate_specific_enemy(specific_enemy)
	
	else:
		var enemy = specific_enemy.instantiate()
		enemy.set_level(current_lvl_enemy)
		enemy.global_position=enemy_position+game_manager.player.global_position
		game_manager.add_child(enemy)
		if enemy.enemy_name=="GhostStrong" and boss_spawned:
			enemy.set_hard(true)



func spawn_enemy_tier_wave(tier:int,quantity:int):
	for i in range( quantity):
		spawn_random_enemy_tier(tier)


func choose_enemy():
	match current_tier_enemy:
		0:	
			return enemy_rat
		1:
			if randf()>.5:
				return enemy_rat
			else:
				return tier1_enemies.pick_random()
		2:
			if randf()>.5:
				return "Rata"#enemigo_rata.enemy_name
			else:
				return tier1_enemies.pick_random()

	return enemy_rat
	
	
func choose_tier_to_spawn():
	match current_tier_enemy:
		0:
			return 0
		1:
			if randf()>.5:
				return 0
			else:
				return 1
		2:
			if randf()>.94:
				return 0
			elif randf()>.55:
				return 1
			else:
				return 2
		3:
			if randf()>.8 and not boss_spawned:
				return 1
			elif randf()>.55 and not boss_spawned:
				return 2
			else:
				return 3
	
	

func randv_circle(min_radius := 360.0, max_radius := 360.0) -> Vector2:
	var r2_max := max_radius * max_radius
	var r2_min := min_radius * min_radius
	var r := sqrt(randf() * (r2_max - r2_min) + r2_min)
	var t := randf() * TAU
	return Vector2(r, 0).rotated(t)



func update_timer_spawn_value(value:float):
	var _g





"""

########  ####  ##     ##  ########  ########    ######  
   ##      ##   ###   ###  ##        ##     ##  ##    ## 
   ##      ##   #### ####  ##        ##     ##  ##       
   ##      ##   ## ### ##  ######    ########    ######  
   ##      ##   ##     ##  ##        ##   ##          ## 
   ##      ##   ##     ##  ##        ##    ##   ##    ## 
   ##     ####  ##     ##  ########  ##     ##   ###### 


"""

func _on_interval_enemy_level_up_timeout():
	current_lvl_enemy+=1


func _on_timer_spawn_timeout(): # Elegimos un tier de enemigos para spawnear	
	var tier=choose_tier_to_spawn()
	spawn_random_enemy_tier(tier)
#	instantiate_specific_enemy(enemigo_fantasma)



func _on_timer_enemy_tier_timeout():
	if current_tier_enemy<3:
		current_tier_enemy+=1
		timer_enemy_tier_value+=10.0
		$TimerEnemyTier.set_wait_time(timer_enemy_tier_value)
		timer_spawn_value-=.1
		$TimerSpawn.set_wait_time(timer_spawn_value)
		wave_enemy_frecuency-=3
		$TimerSpawnWave.set_wait_time(wave_enemy_frecuency)
		print("\n Sumamos Tier: "+str(current_tier_enemy))


func _on_timer_spawn_wave_timeout():
	spawn_enemy_tier_wave(current_tier_enemy,wave_enemy_quantity)


func _on_timer_boss_timeout():
	boss_spawned=true
	SignalBus.boss_spawned.emit()
	timer_spawn_value-=.1
	$TimerSpawn.set_wait_time(timer_spawn_value)
	wave_enemy_frecuency-=3
	$TimerSpawnWave.set_wait_time(wave_enemy_frecuency)
	var enemy_position:Vector2=randv_circle()
	var enemy = boss.instantiate()
	enemy.set_level(current_lvl_enemy)
	enemy.global_position=enemy_position+game_manager.player.global_position
	game_manager.add_child(enemy)
	
