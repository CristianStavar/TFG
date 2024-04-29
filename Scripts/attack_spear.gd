extends "res://Scripts/attack_dagger.gd"



func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		print("++++++++++++++++CHOCO CON EMENIGO!!!!-----: "+str(self)+"       SOY LANZAZO ")
		body.substract_health(damage)
		SignalBus.damage_dealt.emit(damage,attack_name)
		


func ActualizarTimerCooldown(valor:float):
	$TimerCooldown.set_wait_time(valor)

func ActualizarTimerDuracion(valor:float):
	$TimerDuracion.set_wait_time(valor)
	
func update_rotation():
	self.set_rotation(direction.angle()) 
	



func get_cooldown():
	return cooldown


func _on_timer_death_timeout():
	queue_free()
