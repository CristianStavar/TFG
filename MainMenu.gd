extends Control



@onready var main_panel:=$MainPanel
@onready var collections_panel:=$CollectionPanel
@onready var options_panel:=$OptionsPanel
@onready var loading_screen = $LoadingScreen



@onready var statistics_manager:=$StatisticsManager

var back_button:=0



# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("back_to_menu",back_to_menu)
	statistics_manager.load_from_file()




func start_game():
	#Cargar escena nivel y mostrarla
	# Start game leveel
#	main_panel.visible=false
#	loading_screen.visible=true
#	await get_tree().create_timer(0.1).timeout
	var scene = load("res://Escenas/Main.tscn")
	var scene_instance = scene.instantiate()
	scene_instance.set_name("MainGame")
	var root=get_node("/root")
	root.add_child(scene_instance)
	queue_free()
	
	

func show_colection_UI():
	# Show colection screen
	# CArgamos la escena de coleccion y la ponemos encima. Así la tenemos unificada aquí y mientras
	# se está en una partida.
	statistics_manager.load_from_file()
	main_panel.visible=false
	collections_panel.visible=true



func show_options_UI():
	main_panel.visible=false
	options_panel.visible=true


func back_to_menu():
	collections_panel.visible=false
	options_panel.visible=false
	main_panel.visible=true


