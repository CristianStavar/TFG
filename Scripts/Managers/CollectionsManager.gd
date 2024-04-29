extends Node

var statistics_dictionary:Dictionary



@onready var label_rats_killed:=get_node("TabContainer/Estadisticas/LabelRatsKilled")
@onready var label_bats_killed_total:=get_node("TabContainer/Estadisticas/LabelBatsKilled")
@onready var label_spiders_killed_total:=get_node("TabContainer/Estadisticas/LabelSpidersKilled")
@onready var label_crabs_killed_total:=get_node("TabContainer/Estadisticas/LabelCrabsKilled")
@onready var label_ghosts_killed_total:=get_node("TabContainer/Estadisticas/LabelGhostsKilled")
@onready var label_big_ghosts_killed_total:=get_node("TabContainer/Estadisticas/LabelStrongGhostsKilled")
@onready var label_giants_killed_total:=get_node("TabContainer/Estadisticas/LabelGiantsKilled")


@onready var label_dagger_damage_total:=get_node("")
@onready var label_spear_damage_total:=get_node("")
@onready var label_hammer_damage_total:=get_node("")
@onready var label_shield_damage_total:=get_node("")
@onready var label_axe_storm_damage_total:=get_node("")

@onready var label_shield_protection_total:=get_node("")


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("give_statistics_dictionary",update_statistics_dictionary)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func update_statistics_UI():
	label_rats_killed.text="Ratas eliminadas: "+str(statistics_dictionary.enemies_killed.rats)
	label_bats_killed_total.text="Murcielagos eliminados: "+str(statistics_dictionary.enemies_killed.bats)
	label_spiders_killed_total.text="Arañas eliminadass: "+str(statistics_dictionary.enemies_killed.spiders)
	label_crabs_killed_total.text="Cangrejos eliminados: "+str(statistics_dictionary.enemies_killed.crabs)
	label_ghosts_killed_total.text="Fantasmas eliminados: "+str(statistics_dictionary.enemies_killed.ghosts)
	label_big_ghosts_killed_total.text="Fantasmas grandes eliminados: "+str(statistics_dictionary.enemies_killed.big_ghosts)
	label_giants_killed_total.text="Gigantes eliminados: "+str(statistics_dictionary.enemies_killed.giants)
	
	label_dagger_damage_total.text="Daño total de las dagas: "+str(statistics_dictionary.damage_dealt.dagger)
	label_spear_damage_total.text="Daño total de las lanzas: "+str(statistics_dictionary.damage_dealt.spear)
	label_hammer_damage_total.text="Daño total de los martillos: "+str(statistics_dictionary.damage_dealt.hammeer)
	label_shield_damage_total.text="Daño total del escudo: "+str(statistics_dictionary.damage_dealt.hammer)
	label_axe_storm_damage_total.text="Daño total de la tormenta de hachas: "+str(statistics_dictionary.damage_dealt.axe_storm)
	
	
	
	


func ask_for_statistics_dictionary():
	SignalBus.ask_for_statistics_dictionary.emit()

func update_statistics_dictionary(new_dictionary):
	statistics_dictionary=new_dictionary

func _on_button_back_to_menu_pressed():
	SignalBus.back_to_menu.emit()
