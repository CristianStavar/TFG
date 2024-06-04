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
@onready var label_rats_killed:=get_node("TabContainer/Estadisticas/EnemiesKilled/LabelRatsKilled")
@onready var label_bats_killed_total:=get_node("TabContainer/Estadisticas/EnemiesKilled/LabelBatsKilled")
@onready var label_spiders_killed_total:=get_node("TabContainer/Estadisticas/EnemiesKilled/LabelSpidersKilled")
@onready var label_crabs_killed_total:=get_node("TabContainer/Estadisticas/EnemiesKilled/LabelCrabsKilled")
@onready var label_ghosts_killed_total:=get_node("TabContainer/Estadisticas/EnemiesKilled/LabelGhostsKilled")
@onready var label_big_ghosts_killed_total:=get_node("TabContainer/Estadisticas/EnemiesKilled/LabelStrongGhostsKilled")
@onready var label_giants_killed_total:=get_node("TabContainer/Estadisticas/EnemiesKilled/LabelGiantsKilled")


@onready var label_dagger_damage_total:=get_node("TabContainer/Estadisticas/DamageDealt/DamageDagger")
@onready var label_spear_damage_total:=get_node("TabContainer/Estadisticas/DamageDealt/DamageSpear")
@onready var label_hammer_damage_total:=get_node("TabContainer/Estadisticas/DamageDealt/DamageHammer")
@onready var label_shield_damage_total:=get_node("TabContainer/Estadisticas/DamageDealt/DamageShield")
@onready var label_axe_storm_damage_total:=get_node("TabContainer/Estadisticas/DamageDealt/DamageAxeStorm")

@onready var label_shield_protection_total:=get_node("")


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("give_statistics_dictionary",update_statistics_dictionary)
	SignalBus.connect("colection_item_pressed",update_colection_item_info)
	SignalBus.connect("colection_achievement_pressed",update_achievements_info)
	ask_for_statistics_dictionary()


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



func update_statistics_UI():
	print(statistics_dictionary.keys())
	label_rats_killed.text="Ratas eliminadas: "+str(statistics_dictionary.enemies_killed.rats)
	label_bats_killed_total.text="Murcielagos eliminados: "+str(statistics_dictionary.enemies_killed.bats)
	label_spiders_killed_total.text="Arañas eliminadass: "+str(statistics_dictionary.enemies_killed.spiders)
	label_crabs_killed_total.text="Cangrejos eliminados: "+str(statistics_dictionary.enemies_killed.crabs)
	label_ghosts_killed_total.text="Fantasmas eliminados: "+str(statistics_dictionary.enemies_killed.ghosts)
	label_big_ghosts_killed_total.text="Fantasmas grandes eliminados: "+str(statistics_dictionary.enemies_killed.big_ghosts)
	label_giants_killed_total.text="Gigantes eliminados: "+str(statistics_dictionary.enemies_killed.giants)
	
	
	label_dagger_damage_total.text="Daño total de las dagas: %.2f"%statistics_dictionary.damage_dealt.dagger
	label_spear_damage_total.text="Daño total de las lanzas: %.2f"%statistics_dictionary.damage_dealt.spear
	label_hammer_damage_total.text="Daño total de los martillos: %.2f"%statistics_dictionary.damage_dealt.hammer
	label_shield_damage_total.text="Daño total del escudo: %.2f"%statistics_dictionary.damage_dealt.hammer
	label_axe_storm_damage_total.text="Daño total de la tormenta de hachas: %.2f "%statistics_dictionary.damage_dealt.axe_storm
	
	
	
	


func ask_for_statistics_dictionary():
	SignalBus.ask_for_statistics_dictionary.emit()

func update_statistics_dictionary(new_dictionary):
	print("He actualizado el dicionario en colecion")
	statistics_dictionary=new_dictionary

func _on_button_back_to_menu_pressed():
	SignalBus.back_to_menu.emit()



func _on_tab_container_tab_changed(tab):
	if tab==2:
		print("Si soy yo el DOS")
		ask_for_statistics_dictionary()
		update_statistics_UI()
