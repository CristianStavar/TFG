extends Node2D

var player
var upgrades_manager

@onready var spawner:=get_node("Spawner")

@onready var labelEscopeta:=get_node("CharacterBody2D/Camera2D/LabelEscopeta")
@onready var labelSeparacion:=get_node("CharacterBody2D/Camera2D/LabelSeparacion")
@onready var labelEstrella:=get_node("CharacterBody2D/Camera2D/LabelSeparacion2")

@onready var labelCoordenadas:=get_node("CharacterBody2D/Camera2D/LAbelPosition")
@onready var label_health:=get_node("CharacterBody2D/Camera2D/LabelHealth")

@onready var label_experience:=get_node("CharacterBody2D/Camera2D/LabelExperience")
@onready var label_experience2:=get_node("CharacterBody2D/Camera2D/LabelExperience2")
@onready var label_level:=get_node("CharacterBody2D/Camera2D/LabelLevel")


@onready var panel_player_level_up:=get_node("CharacterBody2D/Camera2D/Control")
@onready var panel_button:=get_node("CharacterBody2D/Camera2D/Control/ContinuaJuego")
@onready var botonaso:=get_node("Botonaso")


@onready var panel_card_level_up1:=get_node("")
@onready var panel_card_level_up2:=get_node("")
@onready var panel_card_level_up3:=get_node("")

# Called when the node enters the scene tree for the first time.
func _ready():
	panel_button.pressed.connect(hide_player_level_up)
	botonaso.pressed.connect(hide_player_level_up)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
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





func show_player_level_up():
	get_tree().paused = true
	panel_player_level_up.visible=true
	await get_tree().create_timer(5).timeout
#	hide_player_level_up().
	

func hide_player_level_up():
	print("\nHe puslado seguir\n")
	panel_player_level_up.visible=false
	get_tree().paused = false



func update_position(valor:Vector2):
	labelCoordenadas.text=str(valor)

func update_health(value:float):
	label_health.text="Health: "+str(value)
	
func update_player_ui():
	label_experience.text="Experience: "+str(player.puntosExperiencia)
	label_experience2.text="Experience2: "+str(player.puntosExperienciaSubir)
	label_level.text="Level: "+str(player.nivelActual)
	
	
	
	
	
	
	

func set_player(new_player):
	player=new_player

func set_upgrades_manager(new_upgrades_manager):
	upgrades_manager=new_upgrades_manager

