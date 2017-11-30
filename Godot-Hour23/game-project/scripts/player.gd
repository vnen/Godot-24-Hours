extends KinematicBody2D

onready var bomb_scene = preload("res://scenes/bomb.tscn")
onready var tilemap = get_node("/root/Arena/TileMap")
onready var drop_bomb_cooldown = get_node("DropBombCooldown")
onready var animation = get_node("AnimationPlayer")
onready var sprite = get_node("Sprite")


const textures = [
	preload("res://sprites/player1.png"),
	preload("res://sprites/player2.png"),
	preload("res://sprites/player3.png"),
	preload("res://sprites/player4.png")
]

const WALK_SPEED = 200

var id = null
var nickname = ""
var score = 0
var can_drop_bomb = true
var dead = false
var direction = Vector2()
var current_animation = "idle"
var spawn_pos = Vector2()
var color_index = 0


func _ready():
	sprite.texture = textures[color_index]


slave func _update_pos(new_pos, new_direction):
	position = new_pos
	direction = new_direction
	_update_rot_and_animation(direction)


func _update_rot_and_animation(direction):
	rotation = atan2(direction.y, direction.x)
	var new_animation = "idle"
	if direction:
		new_animation = "walking"
	if new_animation != current_animation:
		animation.play(new_animation)
		current_animation = new_animation


func _physics_process(delta):
	if not is_network_master():
		return
	if not dead:
		if (Input.is_action_pressed("ui_up")):
			direction.y = - WALK_SPEED
		elif (Input.is_action_pressed("ui_down")):
			direction.y =   WALK_SPEED
		else:
			direction.y = 0
	
		if (Input.is_action_pressed("ui_left")):
			direction.x = - WALK_SPEED
		elif (Input.is_action_pressed("ui_right")):
			direction.x =   WALK_SPEED
		else:
			direction.x = 0
	
		move_and_slide(direction)
		_update_rot_and_animation(direction)
	# Send to other peers our player info
	# Note we use unreliable mode given we synchronize during every frame
	# so losing a packet is not an issue
	rpc_unreliable("_update_pos", position, direction)


func _process(delta):
	if not is_network_master() or dead:
		return
	if Input.is_action_just_pressed("ui_select") and can_drop_bomb:
		# A new bomb should be created on the center of the tile the player
		# is currently standing on
		rpc('_dropbomb', tilemap.centered_world_pos(position))
		# Trigger cooldown to avoid spamming bombs
		can_drop_bomb = false
		drop_bomb_cooldown.start()


sync func _dropbomb(pos):
	var bomb = bomb_scene.instance()
	bomb.position = pos
	bomb.owner = self
	get_node("/root/Arena").add_child(bomb)


func _on_DropBombCooldown_timeout():
	can_drop_bomb = true


sync func damage(killer_id):
	# Bomb explosion will trigger this
	dead = true
	gamestate.emit_signal("player_killed", id, killer_id)
	# Make the player respawn at it initial spawn point
	position = spawn_pos
	animation.play("respawn")
	animation.connect("animation_finished", self, "respawn", [], CONNECT_ONESHOT)


func respawn(pos):
	dead = false
