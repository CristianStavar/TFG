extends Button

@export var collectible_holded:Collectible

# Called when the node enters the scene tree for the first time.
func _ready():
	if collectible_holded.unlocked:
		self.icon=collectible_holded.sprite





func _on_pressed():
	SignalBus.colection_collectible_pressed.emit(collectible_holded)
