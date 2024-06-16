extends Control


var player_name:=""
var player_score:=0.0



func update_labels(player:String,score:float):
	player_name=player
	player_score=score
#	print("soy un entry:"+str(self)+"\n y este son mis labels: "+str(player_name) +"      "+str(player_score))
	$LabelPlayer.text=player_name
	$LabelScore.text=str(player_score)

func is_current_player():
	var color = Color(1.0,1.0,0.0,1.0)
	$LabelPlayer.set("theme_override_colors/font_color",color)
	$LabelScore.set("theme_override_colors/font_color",color)
