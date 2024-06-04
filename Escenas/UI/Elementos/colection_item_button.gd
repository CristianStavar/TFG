extends Button

@export var item_holded:CardSkill

# Called when the node enters the scene tree for the first time.
func _ready():
	self.icon=item_holded.sprite





func _on_pressed():
	print("Botonico: "+str(item_holded))
	SignalBus.colection_item_pressed.emit(item_holded)
