extends Resource
class_name CardUpgrade


@export_category("Main info")
@export var name="Daggerino -1"
@export_multiline var description:String
@export var sprite:Texture2D
@export var unlocked:bool
@export var gotten:bool
@export_group("Extra")
@export var attack:PackedScene

@export_category("Upgrade info")
@export_group("Player stats")
@export var player_stat:bool
@export var player_health:bool
@export_subgroup("Extra Properties")
@export var player_health_value:float
@export var player_move_speed:bool
@export var player_move_speed_value:float
@export var player_health_regen:bool
@export var player_health_regen_value:float


