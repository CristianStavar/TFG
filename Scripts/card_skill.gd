extends Resource
class_name CardSkill

#Tipos: Congelado-Sangrado-Veneno
@export var name="Dagge"
@export_multiline var description:String
@export var sprite:Texture2D
@export var unlocked:=false
@export var gotten:bool
@export var unique:bool
@export var attack:PackedScene

@export_enum("Attack", "Upgrade") var card_type: String="Upgrade"
@export_enum("Dagger", "Spear","AxeStorm","Hammer","Shield") 
var attack_type: String=""

@export_category("Upgrade info")

@export_group("Player stats")
@export var player_upgrade:bool
@export_subgroup("Health Card")
@export var player_health_value:float
@export var player_health_regen_value:float
@export_subgroup("Speed Card")
@export var player_move_speed_value:float
@export_subgroup("Damage Card")
@export var player_extra_damage_value:float


@export_group("Dagger stats")
@export var dagger_upgrade:bool
@export_subgroup("Speed Card")
@export var dagger_speed_value:float
@export var dagger_cooldown_value:float
@export_subgroup("Damage Card")
@export var dagger_damage_value:float
@export_subgroup("Extra Dagger Card")
@export var dagger_extra_dagger_value:float
@export_subgroup("Shotgun Card")
@export var dagger_shotgun_upgrade:bool
@export_subgroup("Bounce Card")
@export var dagger_bounce_upgrade:bool


@export_group("Axe Tornado stats")
@export var axe_tornado_upgrade:bool
@export_subgroup("Size Duration Card")
@export var axe_tornado_size_value:float
@export var axe_tornado_duration_value:float
@export_subgroup("Damage CDR Card")
@export var axe_tornado_damage_value:float
@export var axe_tornado_cooldown_value:float
@export_subgroup("Extra Tornado Card")
@export var axe_tornado_extra_tornado_value:float
@export_subgroup("WILD Card")
@export var axe_tornado_wild_upgrade:bool
@export_subgroup("MOVE Card")
@export var axe_tornado_move_upgrade:bool


@export_group("SPEAR stats")
@export var spear_upgrade:bool
@export_subgroup("Damage Card")
@export var spear_damage_value:float
@export_subgroup("CDR Card")
@export var spear_cooldown_value:float
@export_subgroup("Extra Spear Card")
@export var spear_extra_spear_value:float


@export_group("HAMMER stats")
@export var hammer_upgrade:bool
@export_subgroup("Damage Card")
@export var hammer_damage_value:float
@export_subgroup("CDR Card")
@export var hammer_cooldown_value:float
@export var hammer_speed_value:float
@export_subgroup("Extra Spear Card")
@export var hammer_extra_hammer_value:float


@export_group("SHIELD stats")
@export var shield_upgrade:bool
@export_subgroup("Damage Card")
@export var shield_damage_value:float
@export_subgroup("Speed Card")
@export var shield_speed_value:float
@export_subgroup("Extra shield Card")
@export var shield_extra_shield_value:float
@export_subgroup("Solid shield Card")
@export var shield_solid_shield:bool # Stops projectiles







func get_type():
	return card_type


func set_unlocked(value:bool):
	unlocked=value


func set_gotten(value:bool):
	gotten=value
