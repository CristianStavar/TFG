extends Node

# Un autoload con todas las estadisticas? Si no directamente un fichero desde aqui.

#Enemies
var rats_killed_round:=0
var bats_killed_round:=0
var spiders_killed_round:=0
var crabs_killed_round:=0
var ghosts_killed_round:=0
var giants_killed_round:=0
var big_ghosts_killed_round:=0
var boss_killed_round:=0

var rats_killed_total:=0
var bats_killed_total:=0
var spiders_killed_total:=0
var crabs_killed_total:=0
var ghosts_killed_total:=0
var giants_killed_total:=0
var big_ghosts_killed_total:=0
var boss_killed_total:=0


#Time
var total_seconds_survived:=0.0
var round_seconds_survived:=0.0

var total_secrets_found:=0
var round_secrets_found:=0

var total_heal_potions_used:=0
var round_heal_potions_used:=0

var total_barrels_destroyed=0
var round_barrels_destroyed:=0

#Damage
var dagger_damage_round:=0.0
var hammer_damage_round:=0.0
var spear_damage_round:=0.0
var shield_damage_round:=0.0
var shield_projectiles_stoped_round:=0.0
var axe_storm_damage_round:=0.0

var dagger_damage_total:=0.0
var hammer_damage_total:=0.0
var spear_damage_total:=0.0
var shield_damage_total:=0.0
var shield_projectiles_stoped_total:=0.0
var axe_storm_damage_total:=0.0

#Games
var games_played:=0
var games_won:=0




var player_hp_lost:=0





#MISC
var current_round:=0

var save_file="user://save.dat"
var loaded_data
var gameStarted:bool=false
 ######

	# ACHIEVEMENTS

@export var array_achievements:Array[Achievement]

var a_survived_5:=false
var a_survived_10:=false
var a_survived_15:=false
var a_survived_20:=false
var a_survived_30:=false

var a_killed_boss:=false
var a_killed_boss_5:=false

var a_secret_1:=false
var a_secret_10:=false

var a_only_dagger:=false



#checks
var round_boss_killed:=false

var new_achievement:=false




var last_game_score:=0.0
var highest_score:=0.0


##  FIREBASE

var collection_ranking_id:="leaderboard"
var player_display_name:=""




# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("enemy_killed",enemy_killed)
	SignalBus.connect("damage_dealt",damage_dealt)
	SignalBus.connect("projectile_blocked",projectile_blocked)
	SignalBus.connect("time_passed",time_passed)
	SignalBus.connect("potion_taken",potion_taken)
	SignalBus.connect("secret_discovered",secret_discovered)
	SignalBus.connect("barrel_destroyed",barrel_destroyed)
	
	SignalBus.connect("send_only_dagger",check_only_dagger)
	
	SignalBus.connect("ask_for_statistics_dictionary",asked_for_statistics_dictionary)

	SignalBus.connect("player_take_damage",player_take_damage)
	
	SignalBus.connect("delete_save_file",delete_save_file)
	
	SignalBus.connect("game_ended",game_ended)



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


func projectile_blocked():
	shield_projectiles_stoped_round+=1

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
		"GhostStrong":
			big_ghosts_killed_round+=1
		"Giant":
			giants_killed_round+=1
		"Boss":
			boss_killed_round+=1
			round_boss_killed=true
			print("HEMOS MATADO AL JEFEE")
			SignalBus.boss_killed.emit()
			SignalBus.ask_for_only_dagger.emit()
			
			
			

func time_passed(quantity:int):
	print("Hemos sobrevivido estos segundazos: "+str(quantity))
	round_seconds_survived=quantity
	

func potion_taken():
	round_heal_potions_used+=1
	

func barrel_destroyed():
	round_barrels_destroyed+=1

func add_round_stats_to_total():
	rats_killed_total+=rats_killed_round
	spiders_killed_total+=spiders_killed_round
	bats_killed_total+=bats_killed_round
	crabs_killed_total+=crabs_killed_round
	ghosts_killed_total+=ghosts_killed_round
	big_ghosts_killed_total+=big_ghosts_killed_round
	giants_killed_total+=giants_killed_round
	boss_killed_total+=boss_killed_round
	
	dagger_damage_total+=dagger_damage_round
	spear_damage_total+=spear_damage_round
	hammer_damage_total+=hammer_damage_round
	shield_projectiles_stoped_total+=shield_projectiles_stoped_round
	shield_damage_total+=shield_damage_round
	axe_storm_damage_total+=axe_storm_damage_round
	
	total_barrels_destroyed+=round_barrels_destroyed
	total_heal_potions_used+=round_heal_potions_used
	total_secrets_found+=round_secrets_found




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
	shield_projectiles_stoped_round=0
	shield_damage_round=0
	axe_storm_damage_round=0
	
	round_heal_potions_used=0
	round_seconds_survived=0
	

func clean_all_stats():
	rats_killed_total=0
	bats_killed_total=0
	spiders_killed_total=0
	crabs_killed_total=0
	ghosts_killed_total=0
	giants_killed_total=0
	big_ghosts_killed_total=0

	#Time
	total_seconds_survived=0.0

	total_secrets_found=0

	total_heal_potions_used=0
	
	dagger_damage_total=0.0
	hammer_damage_total=0.0
	spear_damage_total=0.0
	shield_damage_total=0.0
	shield_projectiles_stoped_total=0.0
	axe_storm_damage_total=0.0

	#Games
	games_played=0
	games_won=0

	#MISC
	current_round=0
	player_hp_lost=0.0





func save_to_file():
	
	#partidaComenzada=true
	var file=FileAccess.open(save_file,FileAccess.WRITE)
	add_round_stats_to_total()
	check_new_achievements()
	var data=create_save_data()
	print("\n Voy a guardar: \n"+str(data)+"\n")
	file.store_var(data)
	file.close()
	


func create_save_data():
	
	var array_unlocked_achievements:Array[int]
	for i in array_achievements.size():
		if array_achievements[i].unlocked:
			array_unlocked_achievements.append(1)
		elif not array_achievements[i].unlocked:
			array_unlocked_achievements.append(0)
	
	var data_dictionary:Dictionary={
		"array_unlocked_achievements":array_unlocked_achievements,
		"enemies_killed":
			{
				"rats":rats_killed_total,
				"bats":bats_killed_total,
				"spiders":spiders_killed_total,
				"crabs":crabs_killed_total,
				"ghosts":ghosts_killed_total,
				"giants":giants_killed_total,
				"big_ghosts":big_ghosts_killed_total,
				"bosses":boss_killed_total
			},
		"damage_dealt":
			{
				"dagger":dagger_damage_total,
				"spear":spear_damage_total,
				"hammer":hammer_damage_total,
				"shield":shield_damage_total,
				"axe_storm":axe_storm_damage_total
			},
			
		
			
		"game_statistics":
			{
				"games_played":games_played,
				"games_won":games_won,
				"time_survived":total_seconds_survived,
				"secrets_discovered":total_secrets_found,
				"barrels_destroyed":total_barrels_destroyed,
				"potions_taken":total_heal_potions_used,
				"projectiles_blocked":shield_projectiles_stoped_total
			},
		
		"gameStarted":gameStarted,
		"new_achievement":new_achievement
		
	}
	return data_dictionary


func load_from_file():
	
	var file=FileAccess.open(save_file,FileAccess.READ)
	if FileAccess.file_exists(save_file):
		loaded_data=file.get_var()
		print("\n **********************\n Tenemos data nuevaaaao algo. \n "+str(loaded_data)+"\n")
		
		var array_unlocked_achievements:Array
		if loaded_data !=null:
			array_unlocked_achievements=loaded_data.array_unlocked_achievements
		
			rats_killed_total=loaded_data.enemies_killed.rats
			bats_killed_total=loaded_data.enemies_killed.bats
			spiders_killed_total=loaded_data.enemies_killed.spiders
			crabs_killed_total=loaded_data.enemies_killed.crabs
			ghosts_killed_total=loaded_data.enemies_killed.ghosts
			giants_killed_total=loaded_data.enemies_killed.giants
			big_ghosts_killed_total=loaded_data.enemies_killed.big_ghosts
			boss_killed_total=loaded_data.enemies_killed.bosses

			total_seconds_survived=loaded_data.game_statistics.time_survived
			total_heal_potions_used=loaded_data.game_statistics.potions_taken
			total_barrels_destroyed=loaded_data.game_statistics.barrels_destroyed
			total_secrets_found=loaded_data.game_statistics.secrets_discovered
			shield_projectiles_stoped_total=loaded_data.game_statistics.projectiles_blocked

			dagger_damage_total=loaded_data.damage_dealt.dagger
			hammer_damage_total=loaded_data.damage_dealt.hammer
			spear_damage_total=loaded_data.damage_dealt.spear
			shield_damage_total=loaded_data.damage_dealt.shield
			axe_storm_damage_total=loaded_data.damage_dealt.axe_storm
			
			new_achievement=loaded_data.new_achievement
			
			if array_unlocked_achievements!=null:
				for i in array_unlocked_achievements.size():
					if array_unlocked_achievements[i]==0:
						array_achievements[i].unlocked=false
					elif array_unlocked_achievements[i]==1:
						array_achievements[i].unlocked=true
				
		file.close()
		
	else:
		pass
	


func check_achievements_from_menu():
	if new_achievement:
		new_achievement=false
		return true
	elif not new_achievement:
		return false

func check_new_achievements():
	var achievement_unlocked:=0
	if round_seconds_survived>=300 and not array_achievements[0].unlocked:
		array_achievements[0].unlocked=true
		achievement_unlocked+=1
	if round_seconds_survived>=600 and not array_achievements[1].unlocked:
		array_achievements[1].unlocked=true
		achievement_unlocked+=1
	if round_seconds_survived>=900 and not array_achievements[2].unlocked:
		array_achievements[2].unlocked=true
		achievement_unlocked+=1
	if round_seconds_survived>=1200 and not array_achievements[3].unlocked:
		array_achievements[3].unlocked=true
		achievement_unlocked+=1
	if round_seconds_survived>=1800 and not array_achievements[4].unlocked:
		array_achievements[4].unlocked=true
		achievement_unlocked+=1
	
	if rats_killed_total>=200 and not array_achievements[5].unlocked:
		array_achievements[5].unlocked=true
		achievement_unlocked+=1
	if rats_killed_total>=3000 and not array_achievements[6].unlocked:
		array_achievements[6].unlocked=true
		achievement_unlocked+=1
	if rats_killed_total>=5000 and not array_achievements[7].unlocked:
		array_achievements[7].unlocked=true
		achievement_unlocked+=1
	
	if bats_killed_total>=200 and not array_achievements[8].unlocked:
		array_achievements[8].unlocked=true
		achievement_unlocked+=1
	if bats_killed_total>=2000 and not array_achievements[9].unlocked:
		array_achievements[9].unlocked=true
		achievement_unlocked+=1
	
	if spiders_killed_total>=200  and not array_achievements[10].unlocked:
		array_achievements[10].unlocked=true
		achievement_unlocked+=1
	if spiders_killed_total>=2200 and not array_achievements[11].unlocked:
		array_achievements[11].unlocked=true
		achievement_unlocked+=1
	
	if crabs_killed_total>=200 and not array_achievements[12].unlocked:
		array_achievements[12].unlocked=true
		achievement_unlocked+=1
	if crabs_killed_total>=2222 and not array_achievements[13].unlocked:
		array_achievements[13].unlocked=true
		achievement_unlocked+=1
		
	if ghosts_killed_total>=200 and not array_achievements[14].unlocked:
		array_achievements[14].unlocked=true
		achievement_unlocked+=1
	if ghosts_killed_total>=2500 and not array_achievements[15].unlocked:
		array_achievements[15].unlocked=true
		achievement_unlocked+=1
		
	if giants_killed_total>=200 and not array_achievements[16].unlocked:
		array_achievements[16].unlocked=true
		achievement_unlocked+=1
	if giants_killed_total>=4000 and not array_achievements[17].unlocked:
		array_achievements[17].unlocked=true
		achievement_unlocked+=1
	
	if big_ghosts_killed_total>=500 and not array_achievements[18].unlocked:
		array_achievements[18].unlocked=true
		achievement_unlocked+=1
	if big_ghosts_killed_total>=4000 and not array_achievements[19].unlocked:
		array_achievements[19].unlocked=true
		achievement_unlocked+=1
	
	if boss_killed_total>=1 and not array_achievements[20].unlocked:
		array_achievements[20].unlocked=true
		achievement_unlocked+=1
	if boss_killed_total>=5 and not array_achievements[21].unlocked:
		array_achievements[21].unlocked=true
		achievement_unlocked+=1
	
		
	if total_secrets_found>=1 and not array_achievements[22].unlocked:
		array_achievements[22].unlocked=true
		achievement_unlocked+=1
	if total_secrets_found>=10 and not array_achievements[23].unlocked:
		array_achievements[23].unlocked=true
		achievement_unlocked+=1
	
	if total_barrels_destroyed>=5 and not array_achievements[24].unlocked:
		array_achievements[24].unlocked=true
		achievement_unlocked+=1
	if total_barrels_destroyed>=100 and not array_achievements[25].unlocked:
		array_achievements[25].unlocked=true
		achievement_unlocked+=1
	if achievement_unlocked>0:
		new_achievement=true





func check_only_dagger(only_dagger_used):
	if boss_killed_round>=1 and only_dagger_used:
		array_achievements[26].unlocked=true


func secret_discovered():
	round_secrets_found+=1


func update_time_survived(value:float):
	total_seconds_survived+=value


func delete_save_file():
	DirAccess.remove_absolute(save_file) 
	clean_all_stats()


func asked_for_statistics_dictionary():
	SignalBus.give_statistics_dictionary.emit(create_save_data()) 

func return_stats():
	var damage_stats:Array[float]
	damage_stats.append(dagger_damage_round)
	damage_stats.append(spear_damage_round)
	damage_stats.append(hammer_damage_round)
	damage_stats.append(shield_damage_round)
	damage_stats.append(axe_storm_damage_round)

	return damage_stats



#Formula puntos  seg*4+ ( tier ) -hpLost/2

func player_take_damage(value):
	player_hp_lost+=value


func add_up_score() ->float :
	var final_score:=0.0
	var temp_score:=0.0
	final_score+=round_seconds_survived*4
	final_score+=rats_killed_round/2
	final_score+=bats_killed_round
	final_score+=spiders_killed_round
	final_score+=crabs_killed_round*2
	final_score+=ghosts_killed_round*2
	final_score+=giants_killed_round*3
	final_score+=big_ghosts_killed_round*3
	final_score+=boss_killed_round*400
	final_score-=player_hp_lost/2
	
	print("\n\n Puntuacion final de la partida!! : "+str(final_score)+"\n\n" )
	
	return final_score

func game_ended():
	last_game_score=add_up_score()
	if last_game_score>highest_score:
		highest_score=last_game_score
		save_score_to_firebase()
	save_game_data_to_firebase()








""" banner2

######## #### ########  ######## ########     ###     ######  ######## 
##        ##  ##     ## ##       ##     ##   ## ##   ##    ## ##       
##        ##  ##     ## ##       ##     ##  ##   ##  ##       ##       
######    ##  ########  ######   ########  ##     ##  ######  ######   
##        ##  ##   ##   ##       ##     ## #########       ## ##       
##        ##  ##    ##  ##       ##     ## ##     ## ##    ## ##       
##       #### ##     ## ######## ########  ##     ##  ######  ########

"""









func save_score_to_firebase():
	print(" \n *************************************************\n*******************************")
	print("PRocedemos a guardar los puntos")
	var auth=Firebase.Auth.auth
	var player_name:=""
	if auth.localid:
		print("Sesion de usuario comprobada")
		var collection:FirestoreCollection=Firebase.Firestore.collection(collection_ranking_id)
		
		print("\n\n A continuacion la coleccion enteera a ver que tiene: ")
		print(collection)
		print("ahora los trozos: "+str(collection._documents))
		print("Ahora el nombre: "+str(collection.collection_name))
		print("Ahora el auth: "+str(collection.auth))
		print("\n")
		
		if player_display_name=="":
			player_name="Anónimo"
			print(" Le ponemos nuevo nombre al chorbo: "+player_name)
		
		var data:={
			"player_name":player_name,
			"score":highest_score
		}
		
		var document
		print("Tenemos un localid: "+str(auth.localid))
		var document_exist
		document_exist=await collection.get_doc(auth.localid)
		print("Tenemoss un documento que existe tambien: "+str(document_exist))
		if document_exist==null:
			print("No existe el documento asiq lo creamos")
			document=await collection.add(auth.localid,data)
			print("Este es el peaso documento que envio: "+str(document))
		else:
			print("\nYa existe el documento, no hago nada")
			var document_to_update=await collection.get_doc(auth.localid)
			print(" a ver ese documento que leo: ")
			print(document_to_update)
			var db_score=document_to_update.document.score.doubleValue  # .documeent esdonde se guarda el data como tal.
			if highest_score<db_score:
				print("score viejo: "+str(db_score))
				document_to_update.add_or_update_field("score",highest_score)
				print("score nuevo: "+str(highest_score))
			
			if player_display_name!="":
				document_to_update.add_or_update_field("player_name",player_display_name)
			print("\n despuesde cambio:")
			print(document_to_update)
			
			var new_document= await collection.update(document_to_update)
			print(" \nEldocumento ya actualizado en la BD : "+str(new_document))
			
	else:
		print("No hay una sesion de usuario.")




func save_game_data_to_firebase():
	
	print(" \n ********************************************************************************")
	print("PRocedemos a guardar lasmetricas")
	var auth=Firebase.Auth.auth
	if auth.localid:
		print("Sesion de usuario comprobada")
		var collection:FirestoreCollection=Firebase.Firestore.collection(auth.localid)
		print("\n\n A continuacion la coleccion enteera a ver que tiene: ")
		print(collection)
		print("ahora los trozos: "+str(collection._documents))
		print("Ahora el nombre: "+str(collection.collection_name))
		print("Ahora el auth: "+str(collection.auth))
		print("\n")
		

		var data:={
			"game_duration":round_seconds_survived,
			"score":last_game_score
		}
		
		var query: FirestoreQuery = FirestoreQuery.new()
		query.from(auth.localid)
		var results = await Firebase.Firestore.query(query)
		print("EL UQERY LO HACEE PERFE")

		var doc_name="game"+str(results.size())
		var document=await collection.add(doc_name,data)
		print("LOAÑADO SI HE LLEGADO AQUI")
		print("Este es el peaso documento que envio: "+str(document))
	
	else:
		print("No hay una sesion de usuario.")


