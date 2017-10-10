extends Area2D

onready var shot_player = preload("res://scenes/shot.tscn")
onready var explosion = preload("res://scenes/explosion.tscn")

# As we reference the stage and our reload timer we use onready variables
# so that they will be automatically set
onready var stage = get_parent()
# The reload timer is used to limit the shoot rate of the player ship.
# See the "shoot" and "_on_reload_timer_timeout" functions in conjunction 
# with the can_shoot variable for it's usage.
onready var reload_timer = get_node("reload_timer")

const SCREEN_WIDTH = 320
const SCREEN_HEIGHT = 180
const MOVE_SPEED = 150.0

var can_shoot = true

signal destroyed


func _process(delta):
	move_player(delta)
	shoot()
	pass


func move_player(delta):
	# Determine the input direction by checking if any of the
	# arrow keys are being pressed. Note that by pressing i.e.
	# left and right simultaneously the x axis will add up to zero
	# which is what we want.
	var input_dir = Vector2()
	if Input.is_key_pressed(KEY_UP):
		input_dir.y -= 1.0
	if Input.is_key_pressed(KEY_DOWN):
		input_dir.y += 1.0
	if Input.is_key_pressed(KEY_LEFT):
		input_dir.x -= 1.0
	if Input.is_key_pressed(KEY_RIGHT):
		input_dir.x += 1.0
	
	# Move our ship into input direction
	position += (delta * MOVE_SPEED) * input_dir
	
	# Check if we moved past the screen, if so just move us back
	if position.x < 0.0:
		position.x = 0.0
	elif position.x > SCREEN_WIDTH:
		position.x = SCREEN_WIDTH
	if position.y < 0.0:
		position.y = 0.0
	elif position.y > SCREEN_HEIGHT:
		position.y = SCREEN_HEIGHT
	pass


func shoot():
	# If we can shoot and space is pressed we create two new instances
	# of a shot_player, add them to the stage and set their position
	# to the player position with a slight offset
	if Input.is_key_pressed(KEY_SPACE) and can_shoot:
		# Create upper projectile
		var shot_top = shot_player.instance()
		shot_top.position = position + Vector2(9, -5)
		stage.add_child(shot_top)
		
		# Create lower projectile
		var shot_bottom = shot_player.instance()
		shot_bottom.position = position + Vector2(9, 5)
		stage.add_child(shot_bottom)
		
		# Disallow shooting until the reload timer finishes
		can_shoot = false
		reload_timer.start()
	pass


func _on_reload_timer_timeout():
	# Allow shooting when the reload timer finishes
	can_shoot = true
	pass


func destroy():
	# When the player is destroyed we instance an explosion
	# sprite into the stage at the position of the player and
	# then free the player.
	var explosion_instance = explosion.instance()
	explosion_instance.position = position
	stage.add_child(explosion_instance)
	
	# Before freeing we emit an "destroyed" signal to notify the stage
	# that it should show the game over message
	emit_signal("destroyed")
	queue_free()
	pass
