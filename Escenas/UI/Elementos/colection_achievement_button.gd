extends Button

@export var achivement_holded:Achievement
@onready var sprite = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if achivement_holded.unlocked:
		sprite.visible=true





func _on_pressed():
	print("Botonico logro: "+str(achivement_holded))
	SignalBus.colection_achievement_pressed.emit(achivement_holded)
