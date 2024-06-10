extends Node

@export_dir var attacks_directory
@export_dir var upgrades_directory

var choose_cards_ui_array:Array[Node]
var chosen_cards:Array

@export_group("Cards array")
@export_subgroup("Attacks")
@export var all_card_attacks:Array[CardSkill]
@export_subgroup("Upgrades")
@export var all_card_upgrades:Array[CardSkill]


var available_card_attacks : Array[CardSkill]
var available_card_upgrades: Array[CardSkill]

#Tener cartas de mejora que mejoren mas de una cosa, tener muchas que mejoran mierda no es satisfactorio.


var player_current_level:=1

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("player_level_up",on_player_level_up)
	SignalBus.connect("card_chosen",skill_card_chosen)
	SignalBus.connect("card_unlocked",unlock_card)
	SignalBus.connect("lock_maxed_card",lock_maxed_card)
	choose_cards_ui_array.append(get_node("/root/MainGame/UI/Control/NodeCard1"))
	choose_cards_ui_array.append(get_node("/root/MainGame/UI/Control/NodeCard2"))
	choose_cards_ui_array.append(get_node("/root/MainGame/UI/Control/NodeCard3"))
	lock_cards()
	fill_available_card_attacks()
	fill_available_card_upgrades()
	



func fill_available_card_attacks(): 
	for card_attack in all_card_attacks:
		if card_attack.unlocked and not card_attack.gotten:
			print("Ataque: "+str(card_attack.name))
			available_card_attacks.append(card_attack)
	print("CARTAS ATAQUE:")
	print(available_card_attacks)


#Añadimos a la lista de mejoras disponibles las cartas de mejora de ataques conseguidos.
func fill_available_card_upgrades():
	for card_upgrade in all_card_upgrades:
		if card_upgrade.unlocked and not card_upgrade.gotten:
			print("Mejora: "+str(card_upgrade.name))
			available_card_upgrades.append(card_upgrade)




func unlock_card(selected_card):
	print(" \nDESBLOQUEOO   "+str(selected_card.name))
	if selected_card.card_type=="Upgrade":
		for card in all_card_upgrades:
			if card == selected_card:
				card.unlocked=true
	else:
		for card in all_card_attacks:
			if card == selected_card:
				card.unlocked=true


func lock_maxed_card(maxed_card:String):
	match maxed_card:
		"Dagger":
			for upgrade in all_card_upgrades:
					if upgrade.dagger_upgrade and upgrade.dagger_cooldown_value!=0:
						upgrade.unlocked=false
		"Spear":
			for upgrade in all_card_upgrades:
					if upgrade.spear_upgrade and upgrade.spear_cooldown_value!=0:
						upgrade.unlocked=false
		"Hammer":
			for upgrade in all_card_upgrades:
					if upgrade.hammer_upgrade and upgrade.hammer_cooldown_value!=0:
						upgrade.unlocked=false
		"AxeStorm":
			for upgrade in all_card_upgrades:
					if upgrade.axe_tornado_upgrade and upgrade.axe_tornado_cooldown_value!=0:
						upgrade.unlocked=false
		"Shield":
			for upgrade in all_card_upgrades:
					if upgrade.shield_upgrade and upgrade.shield_extra_shield_value!=0:
						upgrade.set_unlocked(false)
					if upgrade.shield_upgrade and upgrade.shield_speed_value!=0:
						upgrade.set_unlocked(false)



func on_player_level_up(player_level:int):
	player_current_level=player_level
	available_card_attacks.clear()
	available_card_upgrades.clear()
	fill_available_card_attacks()
	fill_available_card_upgrades()
	choose_available_cards()
	show_chosen_cards()


func choose_available_cards():
	chosen_cards.clear()

	if player_current_level==2:
		choose_attack_card()
		choose_attack_card()
		choose_upgrade_card()

	elif player_current_level>2 and player_current_level<6:
			choose_upgrade_card()
			choose_upgrade_card()
			choose_upgrade_card()
	else:
		if randf()>.7 and not available_card_attacks.is_empty() :
			choose_attack_card()
		else:
			choose_upgrade_card()
		if randf()>.8 and not available_card_attacks.is_empty():
			choose_attack_card()
		else:
			choose_upgrade_card()
		choose_upgrade_card()



func choose_attack_card():
	print("\n**********  ATAQUES DISPONIBLES"+str(available_card_attacks))
	if available_card_attacks.size()>0:
		var chosen_attack:CardSkill=available_card_attacks.pick_random()
		print(" ELIGO UN ATAQUEEEE ++++++++++++++++++++++++++++++++"+str(chosen_attack.name))
		chosen_cards.append(chosen_attack)
		var index=available_card_attacks.find(chosen_attack)
		available_card_attacks.remove_at(index)
	else:
		choose_upgrade_card()
	

func choose_upgrade_card():
	var chosen_upgrade:CardSkill=available_card_upgrades.pick_random()
	print(" ELIGO UNA MEJORAAAA ------------------------------------"+str(chosen_upgrade.name))
	chosen_cards.append(chosen_upgrade)
	var index=available_card_upgrades.find(chosen_upgrade)
	available_card_upgrades.remove_at(index)
	
	
	


func show_chosen_cards():
	print("\n ESTAS SON LAS CARTAS ELEGIDAS:\n"+str(chosen_cards))
	var index:=0
	for card in choose_cards_ui_array:
		card.fill_card_information(chosen_cards[index])
		index+=1
	



func skill_card_chosen(skill_card:CardSkill):
	if skill_card.unique:
		skill_card.gotten=true
	
	if skill_card.card_type=="Attack":
		match skill_card.attack_type:
			"Spear":
				for upgrade in all_card_upgrades:
					if upgrade.spear_upgrade:
						upgrade.set_unlocked(true)
			"Hammer":
				for upgrade in all_card_upgrades:
					if upgrade.hammer_upgrade and not upgrade.unique:
						upgrade.set_unlocked(true)
			"AxeStorm":
				for upgrade in all_card_upgrades:
					if upgrade.axe_tornado_upgrade and not upgrade.unique:
						upgrade.set_unlocked(true)
			"Shield":
				for upgrade in all_card_upgrades:
					if upgrade.shield_upgrade and not upgrade.unique:
						upgrade.set_unlocked(true)
						


func lock_cards():
	for card in all_card_upgrades:
		if not card.dagger_upgrade and not card.player_upgrade:
			card.set_unlocked(false)
			
	for attack in all_card_attacks:
		attack.set_gotten(false)
		if attack.attack_type=="Shield" or attack.attack_type=="AxeStorm":
			attack.set_unlocked(false)
		

