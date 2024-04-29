extends Node2D

@onready var card_image:=get_node("Image")
@onready var card_name:=get_node("LabelName")
@onready var card_description:=get_node("LabelDescription")

var my_skill

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func fill_card_information(skill):
	my_skill=skill
	card_image.texture=skill.sprite
	card_name.text=skill.name
	card_description.text=skill.description
	
	


func _on_button_pressed():
	print(" He elegido esta skill: "+str(my_skill.name))
	SignalBus.card_chosen.emit(my_skill)
