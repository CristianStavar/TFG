extends Node2D


@export var noise_height_texture:NoiseTexture2D
var noise:Noise
var height_seed:int

@export var noise_objects_texture:NoiseTexture2D
var objects_noise:Noise
var objects_seed:int

@export var token:PackedScene

var width:=400
var height:=400




var noise_value_array=[]

@onready var tile_map:=$"../TileMap"

var grass_ceil:=-.1
var floor_layer:=0
var objects_layer:=1

var source_id:=0
var grass_atlas:=[Vector2(0,0),Vector2(1,0),Vector2(2,0),Vector2(1,0),Vector2(0,0),Vector2(1,0),Vector2(1,0),Vector2(1,0)]
var ground_atlas:=[Vector2(0,15),Vector2(1,15),Vector2(5,15)]


@export var buildings_atlas:Array[PackedScene]
@export var objects_atlas:Array[PackedScene]
#Vector2(2,15),Vector2(3,15),Vector2(4,15)

var tree_atlas:=[Vector2(3,0),Vector2(4,0)]

@export var map_limits:=24

func _ready():
	noise=noise_height_texture.noise
	height_seed=randi_range(0,100)
	noise.seed=height_seed
	
	objects_noise=noise_objects_texture.noise
	objects_seed=randi_range(0,100)
	objects_noise.seed=objects_seed
	generate_world()
	
	



func generate_world():
	var noise_value:float
	var object_noise_value:float
	for x in range(-width/2,width/2):
		for y in range(-height/2,height/2):
			noise_value=noise.get_noise_2d(x,y)
			object_noise_value=objects_noise.get_noise_2d(x,y)
			noise_value_array.append(object_noise_value)
			
			# Map Border
			if x<=-width/2+map_limits or y<=-height/2+map_limits or x>=width/2-map_limits or y>=height/2-map_limits: 
				tile_map.set_cell(objects_layer,Vector2(x,y),source_id,tree_atlas.pick_random())
			
			
			else:
			
				if noise_value>=grass_ceil:
					tile_map.set_cell(floor_layer,Vector2(x,y),source_id,grass_atlas.pick_random(),randi_range(0,1))
				elif noise_value<grass_ceil:
					tile_map.set_cell(floor_layer,Vector2(x,y),source_id,ground_atlas.pick_random(),randi_range(0,3))
					
				if object_noise_value>=.6:
					tile_map.set_cell(objects_layer,Vector2(x,y),source_id,tree_atlas.pick_random())
					var t=buildings_atlas.pick_random().instantiate()
					t.global_position=Vector2(x*15,y*15)
					get_parent().add_child.call_deferred(t)
				if object_noise_value>.8:
					var t=objects_atlas.pick_random().instantiate()
					t.global_position=Vector2(x*14,y*14)
					get_parent().add_child.call_deferred(t)
			
	print("highest: ", noise_value_array.max())
	print("lowest: ", noise_value_array.min())
