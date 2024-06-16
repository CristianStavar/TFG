extends Control



@onready var main_panel:=$MainPanel
@onready var collections_panel:=$CollectionPanel
@onready var options_panel:=$OptionsPanel
@onready var loading_screen = $LoadingScreen



@onready var statistics_manager:=$StatisticsManager
@onready var intro_song:=$AudioStreamPlayer2D

var back_button:=0

var new_achievement:=false
@onready var panel_new_achievements = $PanelNewAchievements



#
#  ____  ____   ____  ____  ____    __    ___  ____ 
# ( ___)(_  _) (  _ \( ___)(  _ \  /__\  / __)( ___)
#  )__)  _)(_   )   / )__)  ) _ < /(__)\ \__ \ )__) 
# (__)  (____) (_)\_)(____)(____/(__)(__)(___/(____)

@onready var panel_login = $PanelLogin


var email:String
var password:String

var collection_ranking_id:="leaderboard"


var save_file_login:="user://saveLogin.dat"

@onready var label_feedback:=$PanelLogin/LabelFeedback



@export var ranking_entry:PackedScene
@onready var ranking_container:=$PanelRanking/ScrollContainer/VBoxContainer
@onready var ranking_panel:=$PanelRanking
@onready var back_to_menu_from_ranking:=$PanelRanking/ButtonBackToMenu


@onready var button_change_name:=$PanelRanking/ButtonChangeName
@onready var line_change_name:=$PanelRanking/LineEditChangeName

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("back_to_menu",back_to_menu)
	statistics_manager.load_from_file()
	new_achievement=statistics_manager.check_achievements_from_menu()
	print("Valor de  LOGROOOOOOOOOOOOOOO :    "+str(new_achievement))
	
	back_to_menu_from_ranking.connect("pressed",back_to_menu)
	
	Firebase.Auth.login_succeeded.connect(on_login_done)
	Firebase.Auth.signup_succeeded.connect(on_signup_done)
	Firebase.Auth.login_failed.connect(on_login_failed)
	Firebase.Auth.signup_failed.connect(on_signup_failed)
	
	button_change_name.connect("pressed",change_player_name_pressed)
	
	var auth=Firebase.Auth.auth
#	print("\nEsto es el authsea loq  sea: "+str(auth))
	if auth.size()!=0:
		panel_login.visible=false
	fill_login_lines()
	
	

	if new_achievement:
		
		panel_new_achievements.visible=true
		await get_tree().create_timer(10).timeout
		panel_new_achievements.visible=false
	


func start_game():
	#Cargar escena nivel y mostrarla
	# Start game leveel
#	main_panel.visible=false
	loading_screen.visible=true
	statistics_manager.save_to_file()
	await get_tree().create_timer(0.1).timeout
	var scene = load("res://Escenas/MainGame.tscn")
	var scene_instance = scene.instantiate()
	scene_instance.set_name("MainGame")
	var root=get_node("/root")
	root.add_child(scene_instance)
	self.visible=false
#	queue_free()
	
	

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
	ranking_panel.visible=false
	main_panel.visible=true




""" banner2

######## #### ########  ######## ########     ###     ######  ######## 
##        ##  ##     ## ##       ##     ##   ## ##   ##    ## ##       
##        ##  ##     ## ##       ##     ##  ##   ##  ##       ##       
######    ##  ########  ######   ########  ##     ##  ######  ######   
##        ##  ##   ##   ##       ##     ## #########       ## ##       
##        ##  ##    ##  ##       ##     ## ##     ## ##    ## ##       
##       #### ##     ## ######## ########  ##     ##  ######  ########

"""



func fill_login_lines():
	var loaded_data
	var file=FileAccess.open(save_file_login,FileAccess.READ)
	if FileAccess.file_exists(save_file_login):
		loaded_data=file.get_var()
		$PanelLogin/LineEditEmail.text=loaded_data.email
		$PanelLogin/LineEditPassword.text=loaded_data.password
		email=loaded_data.email
		password=loaded_data.password
		file.close()




func save_login_lines():
	var file=FileAccess.open(save_file_login,FileAccess.WRITE)
	var data={
		"email":email,
		"password":password
	}
	print("procedemos a guardar los datos de logn: "+str(data))

	file.store_var(data)
	file.close()





func _on_button_login_pressed():
	Firebase.Auth.login_with_email_and_password(email,password)
	label_feedback.text="Conectando"


func _on_button_signup_pressed():
	Firebase.Auth.signup_with_email_and_password(email,password)
	label_feedback.text="Creando cuenta"




func on_login_done(response):
	print(response)
	label_feedback.text="Conectado con exito: \n Iniciando juego."
	Firebase.Auth.save_auth(response)
	save_login_lines()
	await get_tree().create_timer(1.5).timeout
	panel_login.visible=false

func on_signup_done(response):
	print(response)
	label_feedback.text="Cuenta creada con exito: \n Iniciando juego."
	save_login_lines()
	await get_tree().create_timer(2).timeout
	panel_login.visible=false

func on_login_failed(error_code,response):
	print(error_code)
	print(response)
	if response=="INVALID_LOGIN_CREDENTIALS":
		label_feedback.text="Error conectando: \nLa combinacion de credenciales no es correcta."
	else:
		label_feedback.text="Error conectando: %s"%response

func on_signup_failed(error_code,response):
	print(error_code)
	print(response)
	label_feedback.text="Error creando cuenta: %s"%response



func _on_line_edit_email_text_changed(new_text):
	email=new_text


func _on_line_edit_password_text_changed(new_text):
	password=new_text








func clean_ranking():
	for entry in ranking_container.get_children():
		entry.queue_free()



func _on_button_ranking_pressed():
	update_ranking()
	


func update_ranking():
	var auth=Firebase.Auth.auth
	clean_ranking()
	
#	save_score_to_firebase()
	
	ranking_panel.visible=true
	
	# create a query
	var query: FirestoreQuery = FirestoreQuery.new()

	# FROM a collection
	query.from(collection_ranking_id)

	# WHERE points > 20
#	query.where("score", FirestoreQuery.OPERATOR.GREATER_THAN, 20)

	# ORDER BY points, from the user with the best score to the latest
#	query.order_by("player_name", FirestoreQuery.DIRECTION.ASCENDING)

	# LIMIT to the first 10 users
	query.limit(10)
	var results = await Firebase.Firestore.query(query)
	
	print(results)
	print("\n Hueco para ver bien")
	var my_items=results
	my_items.sort_custom(func(a, b): return a.document.score.doubleValue > b.document.score.doubleValue)
	print("\nnuevocoso miralo")
	print(my_items)
	print("\nTamaño de la cosa: "+str(my_items.size()))
	
	
	for entry in my_items:
		var scene_entry=ranking_entry.instantiate()
#		print("existe scene entry: "+str(scene_entry))
#		print("El jugador: "+str(entry.document.player_name.stringValue))
#		print("La puntuacion: "+str(entry.document.score.doubleValue))
		ranking_container.add_child(scene_entry)
		scene_entry.update_labels(entry.document.player_name.stringValue,entry.document.score.doubleValue)
		if auth.localid==entry.doc_name:
			scene_entry.is_current_player()
		
	





func _on_button_logout_pressed():
	Firebase.Auth.logout()




func change_player_name_pressed():
	var new_player_name:String=line_change_name.text
	print(" \n *************************************************\n*******************************")
	print(" \n *************************************************\n*******************************")
	print("PRocedemos a guardar los puntos")
	var auth=Firebase.Auth.auth

	if auth.localid:
		var collection:FirestoreCollection=Firebase.Firestore.collection(collection_ranking_id)
		
		if new_player_name=="":
			print("no hacemos nada")
		

		else:
			var document

			var document_exist
			document_exist=await collection.get_doc(auth.localid)
	#		print("    ++Score +++  TTenemoss un documento que existe tambien: "+str(document_exist))
			if document_exist==null:
				SignalBus.change_player_name.emit(new_player_name)

			else:
				SignalBus.change_player_name.emit(new_player_name)
				var document_to_update=await collection.get_doc(auth.localid)
				document_to_update.add_or_update_field("player_name",new_player_name)

				var new_document= await collection.update(document_to_update)
				print(" \n    ++Score +++  TEldocumento ya actualizado en la BD : "+str(new_document))
			
			await get_tree().create_timer(.5).timeout
			update_ranking()
				
	else:
		print("    ++Score +++  TNo hay una sesion de usuario.")

