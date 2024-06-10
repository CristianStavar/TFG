extends Node

var statistics_dictionary:Dictionary


# ACHIEVEMENTS
@onready var label_achievement_name:=get_node("TabContainer/Logros/LabelName")
@onready var label_achieevement_description:=get_node("TabContainer/Logros/LabelDescription")


# ITEMS
@onready var label_item_name:=get_node("TabContainer/Objetos/PanelInfo/LabelName")
@onready var label_item_description:=get_node("TabContainer/Objetos/PanelInfo/LabelDescription")
@onready var label_item_unique_upgrades:=get_node("TabContainer/Objetos/PanelInfo/LabelUniqueUpgrades")

# STATISTICS
@onready var label_rats_killed:=$TabContainer/Estadisticas/ScrollContainer/Control/EnemiesKilled/LabelRatsKilled
@onready var label_bats_killed_total:=$TabContainer/Estadisticas/ScrollContainer/Control/EnemiesKilled/LabelBatsKilled
@onready var label_spiders_killed_total:=$TabContainer/Estadisticas/ScrollContainer/Control/EnemiesKilled/LabelSpidersKilled
@onready var label_crabs_killed_total:=$TabContainer/Estadisticas/ScrollContainer/Control/EnemiesKilled/LabelCrabsKilled
@onready var label_ghosts_killed_total:=$TabContainer/Estadisticas/ScrollContainer/Control/EnemiesKilled/LabelGhostsKilled
@onready var label_big_ghosts_killed_total:=$TabContainer/Estadisticas/ScrollContainer/Control/EnemiesKilled/LabelStrongGhostsKilled
@onready var label_giants_killed_total:=$TabContainer/Estadisticas/ScrollContainer/Control/EnemiesKilled/LabelGiantsKilled
@onready var label_bosses_killed_total:=$TabContainer/Estadisticas/ScrollContainer/Control/EnemiesKilled/LabelBossesKilled

@onready var label_dagger_damage_total:=$TabContainer/Estadisticas/ScrollContainer/Control/DamageDealt/DamageDagger
@onready var label_spear_damage_total:=$TabContainer/Estadisticas/ScrollContainer/Control/DamageDealt/DamageSpear
@onready var label_hammer_damage_total:=$TabContainer/Estadisticas/ScrollContainer/Control/DamageDealt/DamageHammer
@onready var label_shield_damage_total:=$TabContainer/Estadisticas/ScrollContainer/Control/DamageDealt/DamageShield
@onready var label_axe_storm_damage_total:=$TabContainer/Estadisticas/ScrollContainer/Control/DamageDealt/DamageAxeStorm

@onready var label_secrets_found:=$TabContainer/Estadisticas/ScrollContainer/Control/Misc/LabelSecrets
@onready var label_potions_taken:=$TabContainer/Estadisticas/ScrollContainer/Control/Misc/LabelPotions
@onready var label_barrels_destroyed:=$TabContainer/Estadisticas/ScrollContainer/Control/Misc/LabelBarrels
@onready var label_projectiles_blocked:=$TabContainer/Estadisticas/ScrollContainer/Control/Misc/LabelProjectiles

@onready var achievements:Array[Button]

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("give_statistics_dictionary",update_statistics_dictionary)
	SignalBus.connect("colection_item_pressed",update_colection_item_info)
	SignalBus.connect("colection_achievement_pressed",update_achievements_info)
	await get_tree().create_timer(0.1).timeout
	add_buttons_to_achievements()
	ask_for_statistics_dictionary()
	update_statistics_UI()
	
	update_unlocked_achievements()


func add_buttons_to_achievements():
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer/Achievement)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer/Achievement2)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer/Achievement3)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer/Achievement4)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer/Achievement5)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer/Achievement6)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer/Achievement7)

	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer2/Achievement)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer2/Achievement2)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer2/Achievement3)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer2/Achievement4)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer2/Achievement5)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer2/Achievement6)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer2/Achievement7)

	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer3/Achievement)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer3/Achievement2)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer3/Achievement3)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer3/Achievement4)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer3/Achievement5)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer3/Achievement6)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer3/Achievement7)

	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer4/Achievement)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer4/Achievement2)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer4/Achievement3)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer4/Achievement4)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer4/Achievement5)
	achievements.append($TabContainer/Logros/ScrollContainer/Control/HBoxContainer4/Achievement6)
	

func update_colection_item_info(item):
	print("Desde la colection nuevo item: "+str(item))
	label_item_name.text=item.show_name
	label_item_description.text=item.description
	label_item_unique_upgrades.text=item.unique_upgrades



func update_achievements_info(achievement):
	label_achievement_name.text=achievement.name
	if achievement.unlocked:
		label_achieevement_description.text=achievement.description
	else:
		label_achieevement_description.text=" ??? "


func update_unlocked_achievements():
	var statistics_achievements=statistics_dictionary.array_unlocked_achievements
	for i in achievements.size():
		if statistics_achievements[i]==0:
			achievements[i].achievement_holded.unlocked=false
			achievements[i].update()
		elif statistics_achievements[i]==1:
			achievements[i].achievement_holded.unlocked=true
			achievements[i].update()
	

func update_statistics_UI():
	print(statistics_dictionary.keys())
	label_rats_killed.text="Ratas eliminadas: "+str(statistics_dictionary.enemies_killed.rats)
	label_bats_killed_total.text="Murcielagos eliminados: "+str(statistics_dictionary.enemies_killed.bats)
	label_spiders_killed_total.text="Arañas eliminadass: "+str(statistics_dictionary.enemies_killed.spiders)
	label_crabs_killed_total.text="Cangrejos eliminados: "+str(statistics_dictionary.enemies_killed.crabs)
	label_ghosts_killed_total.text="Fantasmas eliminados: "+str(statistics_dictionary.enemies_killed.ghosts)
	label_big_ghosts_killed_total.text="Fantasmas grandes eliminados: "+str(statistics_dictionary.enemies_killed.big_ghosts)
	label_giants_killed_total.text="Gigantes eliminados: "+str(statistics_dictionary.enemies_killed.giants)
	label_bosses_killed_total.text="Jefes vencidos: "+str(statistics_dictionary.enemies_killed.bosses)
	
	label_dagger_damage_total.text="Daño total de las dagas: %.2f"%statistics_dictionary.damage_dealt.dagger
	label_spear_damage_total.text="Daño total de las lanzas: %.2f"%statistics_dictionary.damage_dealt.spear
	label_hammer_damage_total.text="Daño total de los martillos: %.2f"%statistics_dictionary.damage_dealt.hammer
	label_shield_damage_total.text="Daño total del escudo: %.2f"%statistics_dictionary.damage_dealt.hammer
	label_axe_storm_damage_total.text="Daño total de la tormenta de hachas: %.2f "%statistics_dictionary.damage_dealt.axe_storm
	
	label_potions_taken.text="Pociones tomadas: "+str(statistics_dictionary.game_statistics.potions_taken)
	label_secrets_found.text="Secretos encontrados: "+str(statistics_dictionary.game_statistics.secrets_discovered)
	label_barrels_destroyed.text="Barriles destruidos: "+str(statistics_dictionary.game_statistics.barrels_destroyed)
	label_projectiles_blocked.text="Proyectiles enemigos bloqueados: "+str(statistics_dictionary.game_statistics.projectiles_blocked)
	


func ask_for_statistics_dictionary():
	SignalBus.ask_for_statistics_dictionary.emit()

func update_statistics_dictionary(new_dictionary):
	print("He actualizado el dicionario en colecion")
	statistics_dictionary=new_dictionary

func _on_button_back_to_menu_pressed():
	SignalBus.back_to_menu.emit()



func _on_tab_container_tab_changed(tab):
	if tab==0:
		update_unlocked_achievements()
	if tab==2:
		print("Si soy yo el DOS")
		ask_for_statistics_dictionary()
		update_statistics_UI()
