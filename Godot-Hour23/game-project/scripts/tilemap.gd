extends TileMap

# Node position ofter refere to their center when tile's use top left
# corner so we need this offset for the conversions between the two
onready var tile_offset = get_cell_size() / 2


func centered_world_pos_from_tilepos(tilepos):
	# Return the center of the given tile
	return map_to_world(tilepos) + tile_offset


func centered_world_pos(pos):
	# Round the given position to make it appear on the center of a tile
	return map_to_world(world_to_map(pos)) + tile_offset
