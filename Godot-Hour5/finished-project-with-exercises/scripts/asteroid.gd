extends Area2D

# We need to preload the explosion scene to instantiate it later when
# the asteroid is destroyed by the player
var explosion_scene = preload("res://scenes/explosion.tscn")

var move_speed = 100.0
var score_emitted = false

# The score signal is emitted when an asteroid is destroyed by the player
signal score


func _process(delta):
	# Move the asteroid forward
	position -= Vector2(move_speed * delta, 0.0)

	# If the asteroid moves beyond the left of our screen we destroy it
	if position.x <= -8:
		queue_free()


func _on_asteroid_area_entered(area):
	# If the asteroid hits the player or the a player shot
	# we destroy the the asteroid and emit a score signal
	if area.is_in_group("shot") or area.is_in_group("player"):
		# We need to check if we already emitted a score as this function
		# might be called more than once in a frame. This can happen when 
		# two shots are hitting the asteroid in the same frame.
		# NOTE: queue_free does not immediately delete the asteroid
		if not score_emitted:
			score_emitted = true
			emit_signal("score")
			queue_free()
			
			# When the asteroid is destroyed we instantiate an explosion
			# scene into the stage at the position of the asteroid. 
			var stage_node = get_parent()
			var explosion_instance = explosion_scene.instance()
			explosion_instance.position = position
			stage_node.add_child(explosion_instance)



