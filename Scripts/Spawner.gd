extends Node2D


@export var enemigo_rata:PackedScene
@export var enemigo_fantasma:PackedScene

@onready var game_manager:=get_node("/root/Main")



func _on_timer_timeout():
	invocar_enemigo("Rata")

func invocar_enemigo(tipo:String):
	match tipo:
		"Rata":
			var posicion:Vector2=randv_circle()
			var b = enemigo_rata.instantiate()
			b.global_position=posicion+game_manager.player.global_position
			game_manager.add_child(b)
		"Fantasma":
			var posicion:Vector2=randv_circle()
			var b = enemigo_fantasma.instantiate()
			b.global_position=posicion+game_manager.player.global_position
			game_manager.add_child(b)
			enemigo_fantasma


func randv_circle(min_radius := 800.0, max_radius := 900.0) -> Vector2:
	var r2_max := max_radius * max_radius
	var r2_min := min_radius * min_radius
	var r := sqrt(randf() * (r2_max - r2_min) + r2_min)
	var t := randf() * TAU
	return Vector2(r, 0).rotated(t)
