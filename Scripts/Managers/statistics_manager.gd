extends Node

# Un autoload con todas las estadisticas? Si no directamente un fichero desde aqui.

var rats_killed_round:=0
var bats_killed_round:=0
var spiders_killed_round:=0
var crabs_killed_round:=0
var ghosts_killed_round:=0
var giants_killed_round:=0
var big_ghosts_killed_round:=0

var rats_killed_total:=0
var bats_killed_total:=0
var spiders_killed_total:=0
var crabs_killed_total:=0
var ghosts_killed_total:=0
var giants_killed_total:=0
var big_ghosts_killed_total:=0



var total_seconds_survived:=0
var round_second_survived:=0

var total_heal_potions_used:=0
var round_heal_potions_used:=0


var dagger_damage_round:=0.0
var hammer_damage_round:=0.0
var spear_damage_round:=0.0
var shield_damage_round:=0.0
var shield_damage_negated_round:=0.0
var axe_storm_damage_round:=0.0

var dagger_damage_total:=0.0
var hammer_damage_total:=0.0
var spear_damage_total:=0.0
var shield_damage_total:=0.0
var shield_damage_negated_total:=0.0
var axe_storm_damage_total:=0.0

var games_played:=0
var games_won:=0

var round:=0.0


var save_file="user://save.dat"
var loaded_data
var partidaComenzada:bool=false


var array_achievements:Array

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("enemy_killed",enemy_killed)
	SignalBus.connect("damage_dealt",damage_dealt)
	SignalBus.connect("damage_blocked",damage_blocked)
	SignalBus.connect("time_passed",time_passed)
	SignalBus.connect("item_picked",item_picked)
	
	SignalBus.connect("ask_for_statistics_dictionary",asked_for_statistics_dictionary)
	



func damage_dealt(quantity:float,weapon:String):
	match weapon:
		"Dagger":
			dagger_damage_round+=quantity
		"Spear":
			spear_damage_round+=quantity
		"Hammer":
			hammer_damage_round+=quantity
		"Shield":
			shield_damage_round+=quantity
		"AxeStorm":
			axe_storm_damage_round+=quantity


func damage_blocked(quantity:float):
	shield_damage_negated_round+=quantity

func enemy_killed(enemy_type:String):
	match enemy_type:
		"Rat":
			rats_killed_round+=1
		"Spider":
			spiders_killed_round+=1
		"Bat":
			bats_killed_round+=1
		"Crab":
			crabs_killed_round+=1
		"Ghost":
			ghosts_killed_round+=1
		"BigGhost":
			big_ghosts_killed_round+=1
		"Giant":
			giants_killed_round+=1
			

func time_passed(quantity:int):
	round_second_survived+=quantity
	

func item_picked(item:String):
	round_heal_potions_used+=1

func add_round_stats_to_total():
	rats_killed_total+=rats_killed_round
	spiders_killed_total+=spiders_killed_round
	bats_killed_total+=bats_killed_round
	crabs_killed_total+=crabs_killed_round
	ghosts_killed_total+=ghosts_killed_round
	big_ghosts_killed_total+=big_ghosts_killed_round
	giants_killed_total+=giants_killed_round
	
	dagger_damage_total+=dagger_damage_round
	spear_damage_total+=spear_damage_round
	hammer_damage_total+=hammer_damage_round
	shield_damage_negated_total+=shield_damage_negated_round
	shield_damage_total+=shield_damage_round
	axe_storm_damage_total+=axe_storm_damage_round




func clean_round_stats():
	crabs_killed_round=0
	rats_killed_round=0
	bats_killed_round=0
	ghosts_killed_round=0
	spiders_killed_round=0
	big_ghosts_killed_round=0
	giants_killed_round=0
	
	dagger_damage_round=0
	spear_damage_round=0
	hammer_damage_round=0
	shield_damage_negated_round=0
	shield_damage_round=0
	axe_storm_damage_round=0
	
	round_heal_potions_used=0
	round_second_survived=0
	


func save_to_file():
	
	#partidaComenzada=true
	var file=FileAccess.open(save_file,FileAccess.WRITE)
	var data=create_save_data()
	print("\n Voy a guardar: \n"+str(data)+"\n")
	file.store_var(data)
	file.close()
	


func create_save_data():
	
	var array_unlocked_achievements
	for i in array_achievements.size():
		if array_achievements[i].unlocked:
			array_unlocked_achievements[i].append(1)
		elif not array_achievements[i].unlocked:
			array_unlocked_achievements[i].append(0)
	
	var data_dictionary={
		"enemies_killed":
			{
				"rats":rats_killed_total,
				"bats":bats_killed_total,
				"spiders":spiders_killed_total,
				"crabs":crabs_killed_total,
				"ghosts":ghosts_killed_total,
				"giants":giants_killed_total,
				"big_ghosts":big_ghosts_killed_total				
			},
		"damage_dealt":
			{
				"dagger":dagger_damage_total,
				"spear":spear_damage_total,
				"hammer":hammer_damage_total,
				"shield":shield_damage_total,
				"axe_storm":axe_storm_damage_total
			},
			
		"damage_negated":
			{
				"shield":shield_damage_negated_total
			},
			
		"game_statistics":
			{
				"games_played":games_played,
				"games_won":games_won
			},
		
		"partidaComenzada":partidaComenzada
	}
	return data_dictionary


func load_from_file():
	
	var file=FileAccess.open(save_file,FileAccess.READ)
	if FileAccess.file_exists(save_file):
		loaded_data=file.get_var()
		
		var array_unlocked_achievements:Array
		if loaded_data.array_unlocked_achievements !=null:
			array_unlocked_achievements=loaded_data.array_unlocked_achievements
		
		rats_killed_total=loaded_data.enemies_killed.rats
		bats_killed_total=loaded_data.enemies_killed.bats
		spiders_killed_total=loaded_data.enemies_killed.spiders
		crabs_killed_total=loaded_data.enemies_killed.crabs
		ghosts_killed_total=loaded_data.enemies_killed.ghosts
		giants_killed_total=loaded_data.enemies_killed.giants
		big_ghosts_killed_total=loaded_data.enemies_killed.big_ghosts

		total_seconds_survived=0
		total_heal_potions_used=0

		dagger_damage_total=loaded_data.damage_dealt.dagger
		hammer_damage_total=loaded_data.damage_dealt.hammer
		spear_damage_total=loaded_data.damage_dealt.spear
		shield_damage_total=loaded_data.damage_dealt.shield
		axe_storm_damage_total=loaded_data.damage_dealt.axe_storm
		
		
		if array_unlocked_achievements!=null:
			for i in array_unlocked_achievements.size():
				if array_unlocked_achievements[i]==0:
					array_achievements[i].unlocked=false
				elif array_unlocked_achievements[i]==1:
					array_achievements[i].unlocked=true
			
		

	file.close()



func asked_for_statistics_dictionary():
	SignalBus.give_statistics_dictionary.emit(create_save_data()) 

func print_stats():
	print("\nEstadisticas de cosas--    ++ " +str(dagger_damage_round))
