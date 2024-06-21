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

@onready var starting_story_panel: Button = $StartingStoryPanel


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

@onready var line_edit_email: LineEdit = $PanelLogin/LineEditEmail
@onready var line_edit_password: LineEdit = $PanelLogin/LineEditPassword


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("back_to_menu",back_to_menu)
	statistics_manager.load_from_file()
	new_achievement=statistics_manager.check_achievements_from_menu()
	
	back_to_menu_from_ranking.connect("pressed",back_to_menu)
	
	Firebase.Auth.login_succeeded.connect(on_login_done)
	Firebase.Auth.signup_succeeded.connect(on_signup_done)
	Firebase.Auth.login_failed.connect(on_login_failed)
	Firebase.Auth.signup_failed.connect(on_signup_failed)
	
	button_change_name.connect("pressed",change_player_name_pressed)
	starting_story_panel.connect("pressed",starting_game)
	
	var auth=Firebase.Auth.auth
#	print("\nEsto es el authsea loq  sea: "+str(auth))
	if auth.size()!=0:
		panel_login.visible=false
	fill_login_lines()
	
	if new_achievement and SignalBus.game_type=="EXTRINSICAL":
		panel_new_achievements.visible=true
		await get_tree().create_timer(10).timeout
		panel_new_achievements.visible=false
	
	if SignalBus.game_type!="EXTRINSICAL":
		$MainPanel/Button3.visible=false
		$MainPanel/ButtonRanking.visible=false
	


func start_game():
	main_panel.visible=false
	starting_story_panel.visible=true



	


func starting_game():
	loading_screen.visible=true
	starting_story_panel.visible=false
	statistics_manager.save_to_file()
	await get_tree().create_timer(0.1).timeout
	var scene = load("res://Escenas/MainGame.tscn")
	var scene_instance = scene.instantiate()
	scene_instance.set_name("MainGame")
	var root=get_node("/root")
	root.add_child(scene_instance)
	
	self.visible=false



func show_colection_UI():
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

	file.store_var(data)
	file.close()





func _on_button_login_pressed():
	if email!="" and password!="":
		Firebase.Auth.login_with_email_and_password(email,password.sha256_text())
		#Firebase.Auth.login_with_email_and_password(email,password)
		label_feedback.text="Conectando"
	elif  email=="" and password=="":
		Firebase.Auth.login_with_email_and_password(line_edit_email.text,line_edit_password.text.sha256_text())
		#Firebase.Auth.login_with_email_and_password(line_edit_email.text,line_edit_password.text)
		label_feedback.text="Conectando"


func _on_button_signup_pressed():
	if email!="" and password!="":
		Firebase.Auth.signup_with_email_and_password(email,password.sha256_text())  
		#Firebase.Auth.signup_with_email_and_password(email,password) 
		label_feedback.text="Creando cuenta"
	elif  email=="" and password=="":
		Firebase.Auth.signup_with_email_and_password(line_edit_email.text,line_edit_password.text.sha256_text())
		#Firebase.Auth.signup_with_email_and_password(line_edit_email.text,line_edit_password.text)
		label_feedback.text="Creando cuenta"




func on_login_done(response):
	label_feedback.text="Conectado con exito: \n Iniciando juego."
	Firebase.Auth.save_auth(response)
	save_login_lines()
	await get_tree().create_timer(1.5).timeout
	panel_login.visible=false

func on_signup_done(response):
	label_feedback.text="Cuenta creada con exito: \n Iniciando juego."
	save_login_lines()
	await get_tree().create_timer(2).timeout
	panel_login.visible=false

func on_login_failed(error_code,response):
	if response=="INVALID_LOGIN_CREDENTIALS":
		label_feedback.text="Error conectando: \nLa combinacion de credenciales no es correcta."
	elif response=="Error connecting to auth service":
		label_feedback.text="Error iniciando seesion: %s"%response
		await get_tree().create_timer(2).timeout
#		panel_login.visible=false
	else:
		label_feedback.text="Error conectando: %s"%response

func on_signup_failed(error_code,response):
	label_feedback.text="Error creando cuenta: %s"%response
	if response=="Error connecting to auth service":
		label_feedback.text="Error creando cuenta: %s"%response
		await get_tree().create_timer(2).timeout
#		panel_login.visible=false



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
	if auth.localid:
		clean_ranking()
		
	#	save_score_to_firebase()
		ranking_panel.visible=true
		
		# create a query
		var query: FirestoreQuery = FirestoreQuery.new()
		# FROM a collection
		query.from(collection_ranking_id)

		var results = await Firebase.Firestore.query(query)
		var my_items=results
		my_items.sort_custom(func(a, b): return a.document.score.doubleValue > b.document.score.doubleValue)
		var top_ten_items:Array
		for i in 10:
			if my_items.size()>i:
				top_ten_items.append(my_items[i])
		
		if my_items.size()==0:
			var scene_entry=ranking_entry.instantiate()
			ranking_container.add_child(scene_entry)
			scene_entry.update_labels("Aún no hay nadie digno.",0.0)
			
		
		for entry in top_ten_items:
			var scene_entry=ranking_entry.instantiate()
			ranking_container.add_child(scene_entry)
			scene_entry.update_labels(entry.document.player_name.stringValue,entry.document.score.doubleValue)
			if auth.localid==entry.doc_name:
				scene_entry.is_current_player()
			
		


func _on_button_logout_pressed():
	Firebase.Auth.logout()
	panel_login.visible=true


func change_player_name_pressed():
	var new_player_name:String=line_change_name.text
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
