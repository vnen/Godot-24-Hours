extends Node2D

onready var tilemap = get_node("/root/Arena/TileMap")
onready var animation = get_node("AnimationPlayer")


var owner = null
var direction = null
# Explosion animation depends on this
enum {CENTER, SIDE, SIDE_BORDER}
var type = CENTER


func _ready():
	# Set the explosion animation depending of it type
	if type == CENTER:
		animation.play("explosion_center")
	elif type == SIDE:
		animation.play("explosion_side")
	else:
		animation.play("explosion_side_border")
	# Only center explosion is symetric, others must be rotated
	# according to there direction
	if direction:
		rotation = atan2(direction.y, direction.x)
	# Retrieve the tile hit by the explosion and flatten it to the ground
	var tile_pos = tilemap.world_to_map(position)
	var tile_background_id = tilemap.tile_set.find_tile_by_name("BackgroundBrick")
	tilemap.set_cellv(tile_pos, tile_background_id)

	if not is_network_master():
		return
	# Now that we know which tile is blowing up, retrieve the players
	# and destroy them if they are on it
	for player in  get_tree().get_nodes_in_group('players'):
		var playerpos = tilemap.world_to_map(player.position)
		if playerpos == tile_pos:
			player.rpc("damage", owner.id)


func _on_AnimationPlayer_animation_finished( name ):
	# Explosion finished, we can remove the node
	queue_free()
