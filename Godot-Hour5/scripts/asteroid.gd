extends Area2D

# We need to preload the explosion scene to instantiate it later when
# the asteroid is destroyed by the player
onready var explosion = preload("res://scenes/explosion.tscn")

# We use a timer to let the asteroid blink briefly when being hit by the player
onready var damage_blink_timer = get_node("damage_blink_timer")


var health = 3
var speed = 100.0
var is_destroyed = false

# The score signal is emitted when an asteroid is destroyed by the player
signal score


func _process(delta):
	# Move the asteroid forward
	position -= Vector2(speed * delta, 0.0)

	# If the asteroid moves beyond the left of our screen we destroy it
	if position.x <= -100:
		queue_free()
	pass


func _on_asteroid_area_entered(player):
	# If the asteroid hits the player we destroy the player
	# and the asteroid. Note: we know that we hit the player
	# because our Area2D's collision mask is set to player.
	player.destroy()
	destroy()
	pass


func do_damage(amount):
	# When get hit we set the asteroids color modulate
	# to a bright white
	modulate = Color(5.0, 5.0, 5.0)
	damage_blink_timer.start()
	
	# We subtract the damage amount from our current health
	# and if the health reaches zero we destroy the asteroid
	health -= amount
	if health <= 0 and not is_destroyed:
		# We need to ask for (and set) the is_destroyed variable
		# because do_damage might be called two times in a frame if two shots
		# hit the asteroid at the same time. With the is_destroyed variable
		# we prevent the case where we get two score-points for one asteroid.
		is_destroyed = true
		emit_signal("score")
		destroy()
	pass


func _on_damage_blink_timer_timeout():
	# When the damage blink timer finishes we set the 
	# color modulate of the asteroid back to normal
	modulate = Color(1.0, 1.0, 1.0)
	pass


func destroy():
	# When the asteroid is destroyed we instantiate an explosion
	# sprite into the stage at the position of the asteroid and
	# then free the asteroid itself. 
	var explosion_instance = explosion.instance()
	explosion_instance.position = position
	var stage = get_parent()
	stage.add_child(explosion_instance)
	queue_free()
	pass
