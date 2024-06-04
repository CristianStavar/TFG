extends Control

@export var sprite:Texture
var damage_label:Label


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture=sprite
	damage_label=$LabelDamage


func update_damage_label(value):
	damage_label.text="Daño causado:\n%.1f" %value
	
