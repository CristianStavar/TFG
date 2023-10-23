extends Node2D

var player

@onready var spawner:=get_node("Spawner")

@onready var labelEscopeta:=get_node("CharacterBody2D/Camera2D/LabelEscopeta")
@onready var labelSeparacion:=get_node("CharacterBody2D/Camera2D/LabelSeparacion")
@onready var labelEstrella:=get_node("CharacterBody2D/Camera2D/LabelSeparacion2")

@onready var labelCoordenadas:=get_node("CharacterBody2D/Camera2D/LAbelPosition")
@onready var label_health:=get_node("CharacterBody2D/Camera2D/LabelHealth")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(_delta):
	
	if Input.is_action_pressed("spawn"):
		spawner.invocar_enemigo("Rata")
	if Input.is_action_pressed("spawn2"):
		spawner.invocar_enemigo("Fantasma")


func ActivarEstadoArma(estado:String,activo:bool):
	if activo:
		match estado:
			"Escopeta":
				labelEscopeta.modulate=Color.WEB_GREEN   #.add_color_override("default_color", Color(1,0,0,1))
			"Separacion":
				labelSeparacion.modulate=Color.WEB_GREEN
			"Estrella":
				labelEstrella.modulate=Color.WEB_GREEN
				
	elif not activo:
		match estado:
			"Escopeta":
				labelEscopeta.modulate=Color.DARK_RED
			"Separacion":
				labelSeparacion.modulate=Color.DARK_RED
			"Estrella":
				labelEstrella.modulate=Color.DARK_RED




func update_position(valor:Vector2):
	labelCoordenadas.text=str(valor)

func update_health(value:float):
	label_health.text="Health: "+str(value)
