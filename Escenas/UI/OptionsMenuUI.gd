extends Control

@onready var panel_delete_save_warning = $PanelDeleteSaveWarning
@export var on_main_menu:=true



func _on_button_back_to_menu_pressed():
	if on_main_menu:
		SignalBus.back_to_menu.emit()
	else:
		self.visible=false


func _on_button_delete_save_pressed():
	delete_save_warning()
	
	
func delete_save_warning():
	panel_delete_save_warning.visible=!panel_delete_save_warning.visible


func confirmation_delete_save():
	SignalBus.delete_save_file.emit()
	delete_save_warning()
