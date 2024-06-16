extends Resource
class_name Collectible


@export var name="Llave de la ciudad"
@export_multiline var description:String
@export var sprite:Texture2D
@export var unlocked:=false


func collectible_unlocked():
	unlocked=true
