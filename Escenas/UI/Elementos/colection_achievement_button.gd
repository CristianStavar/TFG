extends Button

@export var achievement_holded:Achievement
@onready var unlocked_sprite = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if achievement_holded.sprite!=null:
		icon=achievement_holded.sprite
	unlocked_sprite.visible=achievement_holded.unlocked





func _on_pressed():
	print("Botonico logro: "+str(achievement_holded))
	SignalBus.colection_achievement_pressed.emit(achievement_holded)

func update():
	unlocked_sprite.visible=achievement_holded.unlocked
