extends Node2D

var can_place = true
onready var level = Game.palace.get_node("YSort")
var current_item  # a PackedScene
var current_tileset
var current_tileset_name

var placing_tileset = false
var removing_tileset = false
var tile_id
var tilemap
var tile_set

const items_whose_direction_is_random = ["Fish"]

func _ready():
	hide()

func ui_cancel():
	current_item = null
	current_tileset = null
	current_tileset_name = null
	hide()

func _process(delta):
	global_position = get_global_mouse_position()
	if can_place:
		if current_item != null:
			if Input.is_action_just_pressed("click"):
				var new_item = current_item.instance()
				level.add_child(new_item)
				new_item.set_owner(Game.current_scene)
				new_item.global_position = global_position
				print('new_item.name = ', new_item.name)
				for change in items_whose_direction_is_random:
					if change in new_item.name and randi() % 2 == 0:
#				if new_item.name.split('@')[1].replace('Placed', '') in items_whose_direction_is_random:
						new_item.scale.x = -new_item.scale.x
#			elif Input.is_action_just_pressed("right_click"):
#				remove_placed_item_on_position(global_position)
		elif current_tileset:
			tilemap = Game.palace.get_node(current_tileset)
			tile_set = tilemap.tile_set
			if Input.is_action_just_pressed("click"):
				tile_id = tile_set.find_tile_by_name(current_tileset_name)
				placing_tileset = true
			if Input.is_action_just_released("click"):
				placing_tileset = false
			elif Input.is_action_just_pressed("right_click"):
				removing_tileset = true
				tile_id = -1  # We clear
			elif Input.is_action_just_released("right_click"):
				removing_tileset = false
		if placing_tileset or removing_tileset:
			var tilemap_position = tilemap.world_to_map(global_position)
			tilemap.set_cell(tilemap_position.x, tilemap_position.y, tile_id)
			var start = Vector2(tilemap_position.x - 1, tilemap_position.y - 1)
			var end = Vector2(tilemap_position.x + 1, tilemap_position.y + 1)
			tilemap.update_bitmask_region(start, end)
