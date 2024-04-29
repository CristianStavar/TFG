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
	choose_cards_ui_array.append(get_node("/root/MainGame/UI/Control/NodeCard1"))
	choose_cards_ui_array.append(get_node("/root/MainGame/UI/Control/NodeCard2"))
	choose_cards_ui_array.append(get_node("/root/MainGame/UI/Control/NodeCard3"))
	fill_available_card_attacks()
	fill_available_card_upgrades()





func fill_available_card_attacks(): 
	for card_attack in all_card_attacks:
		if card_attack.unlocked and not card_attack.gotten:
			print("Ataque: "+str(card_attack.name))
			available_card_attacks.append(card_attack)
		else:
			print("GOTTEN ESTA A TRUEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE  ATAQUEEEEE")
	print("CARTAS ATAQUE:")
	print(available_card_attacks)


#Añadimos a la lista de mejoras disponibles las cartas de mejora de ataques conseguidos.
func fill_available_card_upgrades():
	for card_upgrade in all_card_upgrades:
		if card_upgrade.unlocked and not card_upgrade.gotten:
			print("Mejora: "+str(card_upgrade.name))
			available_card_upgrades.append(card_upgrade)
		else:
			print("GOTTEN ESTA A TRUEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE")
	print("CARTAS Mejora:")
	print(available_card_upgrades)



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
		choose_attack_card()

	elif player_current_level>2 and player_current_level<6:
		choose_attack_card()
		if randf()>.5:
			choose_attack_card()
			choose_upgrade_card()
		else:
			choose_upgrade_card()
			choose_upgrade_card()
	else:
		if randf()>.66 and not available_card_attacks.is_empty() :
			choose_attack_card()
		else:
			choose_upgrade_card()
		if randf()>.75 and not available_card_attacks.is_empty():
			choose_attack_card()
		else:
			choose_upgrade_card()
		if randf()>.8 and not available_card_attacks.is_empty():
			choose_attack_card()
		else:
			choose_upgrade_card()



func choose_attack_card():
	print("\n**********  ATAQUES DISPONIBLES"+str(available_card_attacks))
	if available_card_attacks.size()>0:
		var chosen_attack:CardSkill=available_card_attacks.pick_random()
		print("\n ELIGO UN ATAQUEEEE ++++++++++++++++++++++++++++++++"+str(chosen_attack.name))
		chosen_cards.append(chosen_attack)
		var index=available_card_attacks.find(chosen_attack)
		available_card_attacks.remove_at(index)
	else:
		choose_upgrade_card()
	

func choose_upgrade_card():
	print("\n**********  MEJORAS DISPONIBLES"+str(available_card_upgrades))
	var chosen_upgrade:CardSkill=available_card_upgrades.pick_random()
	print("\n ELIGO UNA MEJORAAAA ------------------------------------"+str(chosen_upgrade.name))
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
		print("Y la guardamos. ")
	
	if skill_card.card_type=="Attack":
		match skill_card.attack_type:
			"Spear":
				for upgrade in all_card_upgrades:
					if upgrade.spear_upgrade:
						upgrade.unlocked=true
			"Hammer":
				for upgrade in all_card_upgrades:
					if upgrade.hammer_upgrade:
						upgrade.unlocked=true
			"AxeTornado":
				for upgrade in all_card_upgrades:
					if upgrade.axe_tornado_upgrade:
						upgrade.unlocked=true
			"Shield":
				for upgrade in all_card_upgrades:
					if upgrade.shield_upgrade:
						upgrade.unlocked=true


func save_skill_resource(skill_card:CardSkill):
	var g
