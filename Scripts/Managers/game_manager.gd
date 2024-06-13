extends Node2D

var player
var upgrades_manager

@onready var spawner:=get_node("Spawner")

@onready var statistics_manager:=get_node("StatisticsManager")





@onready var label_experience:=get_node("CharacterBody2D/Camera2D/LabelExperience")
@onready var label_experience2:=get_node("CharacterBody2D/Camera2D/LabelExperience2")



@onready var panel_player_level_up:=get_node("UI/Control")
@onready var panel_button:=get_node("UI/Control/ContinuaJuego")



@onready var UI_button_pause_game:=get_node("UI/ButtonPauseGame")


@onready var pause_menu_ui:=get_node("UI/PauseMenuUI")
@onready var game_ended_panel:=get_node("UI/PauseMenuUI/GameEndedPanel")
@onready var game_paused_panel:=get_node("UI/PauseMenuUI/GamePausedPanel")
@onready var options_panel:=get_node("UI/OptionsMenuUI")


@onready var pause_menu_options_button:=get_node("UI/PauseMenuUI/ButtonOptions")
@onready var pause_menu_restart_game_button:=get_node("UI/PauseMenuUI/GameEndedPanel/ButtonRestartGame")
@onready var pause_menu_resume_game_button:=get_node("UI/PauseMenuUI/GamePausedPanel/ButtonResumeGame")
@onready var go_main_menu_button:=get_node("UI/PauseMenuUI/ButtonMainMenu")
@onready var panel_go_to_main_menu:=get_node("UI/PauseMenuUI/PanelGoToMain")
@onready var button_confirmation_main_menu:=get_node("UI/PauseMenuUI/PanelGoToMain/ButtonConfirmationMenu")
@onready var button_deny_main_menu:=get_node("UI/PauseMenuUI/PanelGoToMain/ButtonDenyMenu")


var weapon_pause_array:Array[Control]



var game_is_paused:=false
var time_passed:=0.0
var time_label

@onready var label_level = $UI/LabelLevel
@onready var panel_loading_game:=$UI/PauseMenuUI/LoadingScreen


@onready var bg_song:=$BGSong
@onready var boss_song:=$BossSong
@onready var sound_player_dead = $SoundPlayerDead


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("player_level_up",show_player_level_up)
	SignalBus.connect("card_chosen",hide_player_level_up)
	SignalBus.connect("player_died",player_died)
	SignalBus.connect("boss_killed",boss_killed)
	SignalBus.connect("boss_spawned",boss_spawned)
	
#	get_tree().current_scene.set_name("MainGame")
	
	pause_menu_options_button.connect("pressed", show_options)
	pause_menu_resume_game_button.connect("pressed",resume_game)
	pause_menu_restart_game_button.connect("pressed",restart_game)
	UI_button_pause_game.connect("pressed",pause_game)
	go_main_menu_button.connect("pressed",go_to_main_menu_button_pressed)
	
	button_deny_main_menu.connect("pressed",go_to_main_menu_button_pressed)
	button_confirmation_main_menu.connect("pressed",go_to_main_menu)
	
	panel_button.pressed.connect(hide_player_level_up)

	
	
	
	weapon_pause_array.append($UI/PauseMenuUI/UnlockedWeapons/WeaponPauseDagger)
	weapon_pause_array.append($UI/PauseMenuUI/UnlockedWeapons/WeaponPauseSpear)
	weapon_pause_array.append($UI/PauseMenuUI/UnlockedWeapons/WeaponPauseHammer)
	weapon_pause_array.append($UI/PauseMenuUI/UnlockedWeapons/WeaponPauseShield)
	weapon_pause_array.append($UI/PauseMenuUI/UnlockedWeapons/WeaponPauseAxeStorm)
	
	time_label=$UI/LabelTime
	
	statistics_manager.load_from_file()
	
	
	Firebase.Auth.login_with_email_and_password("cuenta1@test.po","123456")
	
#	update_player_ui()








func _physics_process(delta):	
	if not game_is_paused :
		time_passed+=delta
	var minutes=time_passed/60
	var seconds=fmod(time_passed,60)
	var time_text="%02d:%02d"%[minutes,seconds]#  ; 
	time_label.text= time_text




func show_player_level_up(_player_current_level):
	get_tree().paused = true
	game_is_paused=true
	panel_player_level_up.visible=true
	#await get_tree().create_timer(5).timeout
#	hide_player_level_up().

#	var auth=Firebase.Auth.auth
#	print("Sigo conectado porq esto funcoinabien: "+str(auth.localid))

func hide_player_level_up(_skill:CardSkill):
	update_player_ui()
	print("\nHe puslado seguir\n")
	panel_player_level_up.visible=false
	get_tree().paused = false
	game_is_paused=false



func show_options():
	options_panel.visible=!options_panel.visible







	
func update_player_ui():
	label_level.text="Nivel: "+str(player.current_level)

	
func player_died():
	sound_player_dead.play()
	update_pause_menu()
	pause_menu_ui.visible=true
	game_ended_panel.visible=true
	game_paused_panel.visible=false
	get_tree().paused = true
	game_is_paused=true
	SignalBus.time_passed.emit(time_passed)
	SignalBus.game_ended.emit()
	statistics_manager.check_new_achievements()
	statistics_manager.save_to_file()
	

func set_player(new_player):
	player=new_player

func set_upgrades_manager(new_upgrades_manager):
	upgrades_manager=new_upgrades_manager

#PASUE GAME

func pause_game():
	pause_menu_ui.visible=true
	game_ended_panel.visible=false
	game_paused_panel.visible=true
	update_pause_menu()
	get_tree().paused = true
	game_is_paused=true


func update_pause_menu():
	var damage_array:Array[float]
	damage_array=statistics_manager.return_stats()
	if player.spear_gotten:
		weapon_pause_array[1].visible=true
	if player.hammer_gotten:
		weapon_pause_array[2].visible=true
	if player.shield_gotten:
		weapon_pause_array[3].visible=true
	if player.axe_tornado_gotten:
		weapon_pause_array[4].visible=true
	for i in damage_array.size():
		weapon_pause_array[i].update_damage_label(damage_array[i])
	



func resume_game():
	pause_menu_ui.visible=false

	get_tree().paused = false
	game_is_paused=false


func restart_game():

	print("\n Voy a reiniciar sisisis")
	if get_tree():
		panel_loading_game.visible=true
		reload_game()
#		get_tree().reload_current_scene()

#	await get_tree().create_timer(0.1).timeout
#	get_tree().paused = false
#	game_is_paused=false

func reload_game():
#	get_tree().reload_current_scene()

	await get_tree().create_timer(0.1).timeout
	var scene = load("res://Escenas/MainGame.tscn")
	var scene_instance = scene.instantiate()
#	get_tree().unload_current_scene()
	self.set_name("pepe")
	scene_instance.set_name("MainGame")
	var root=get_node("/root")
	root.add_child(scene_instance)
	get_tree().paused = false
	game_is_paused=false
	queue_free()

func go_to_main_menu_button_pressed():
	panel_go_to_main_menu.visible=!panel_go_to_main_menu.visible


func go_to_main_menu():
#	get_tree().paused = false
#	pause_menu_ui.visible=false
#	self.visible=false
	
	SignalBus.time_passed.emit(time_passed)
	SignalBus.game_ended.emit()
	statistics_manager.check_new_achievements()
	statistics_manager.save_to_file()
	var scene = load("res://Escenas/UI/MainMenuUI.tscn")
	var scene_instance = scene.instantiate()
	scene_instance.set_name("MainMenu")
	var root=get_node("/root")
	root.add_child(scene_instance)
	get_tree().paused = false
	game_is_paused=false
	queue_free()

	



func boss_spawned():
	bg_song.stop()
	boss_song.play()

func boss_killed():
	boss_song.stop()
	bg_song.play()







func get_time_passed():
	return time_passed


#Timer

func _on_timer_shield_unlock_timeout():
	player.shield_time_passed=true
	player.check_for_new_upgrades()


func _on_timer_axe_storm_unlock_timeout():
	player.axe_tornado_time_passed=true
	player.check_for_new_upgrades()
