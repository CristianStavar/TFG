extends Node2D


@onready var sprite:=$Sprite2D
@export var is_visible:=false

@onready var sound_secret_found = $SoundSecretFound


func _ready():
	sprite.visible=is_visible

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		SignalBus.secret_discovered.emit()
		sound_secret_found.play()
		await get_tree().create_timer(0.1).timeout
		queue_free()
