extends Area2D

var shot_scene = preload("res://scenes/shot.tscn")
var explosion_scene = preload("res://scenes/explosion.tscn")

const SCREEN_WIDTH = 320
const SCREEN_HEIGHT = 180
const MOVE_SPEED = 150.0

var can_shoot = true

signal destroyed


func _process(delta):
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
	
	# Check if we moved past the screen, if so just move us back.
	# Exercise 1: Sprite should be inside the screen
	if position.x < 8:
		position.x = 8
	elif position.x > SCREEN_WIDTH - 8:
		position.x = SCREEN_WIDTH - 8
	if position.y < 8:
		position.y = 8
	elif position.y > SCREEN_HEIGHT - 8:
		position.y = SCREEN_HEIGHT - 8
	
	
	# If we can shoot and space is pressed we create two new instances
	# of a shot_scene, add them to the stage and set their position
	# to the player position with a slight offset
	if Input.is_key_pressed(KEY_SPACE) and can_shoot:
		var stage_node = get_parent()
		
		# Create upper projectile
		var shot_top = shot_scene.instance()
		shot_top.position = position + Vector2(9, -5)
		stage_node.add_child(shot_top)
		
		# Create lower projectile
		var shot_bottom = shot_scene.instance()
		shot_bottom.position = position + Vector2(9, 5)
		stage_node.add_child(shot_bottom)
		
		# Disallow shooting until the reload timer finishes
		can_shoot = false
		get_node("reload_timer").start()


func _on_reload_timer_timeout():
	# Allow shooting when the reload timer finishes
	can_shoot = true


func _on_player_area_entered(area):
	if area.is_in_group("asteroid"):
		# When the asteroid is destroyed we instantiate an explosion
		# scene into the stage at the position of the asteroid and
		# then free the asteroid itself. 
		var stage_node = get_parent()
		var explosion_instance = explosion_scene.instance()
		explosion_instance.position = position
		stage_node.add_child(explosion_instance)
		
		# Before freeing we emit an "destroyed" signal to notify the stage
		# that it should show the game over message
		emit_signal("destroyed")
		queue_free()
