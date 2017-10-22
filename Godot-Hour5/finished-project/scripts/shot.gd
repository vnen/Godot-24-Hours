extends Area2D

const SCREEN_WIDTH = 320
const MOVE_SPEED = 500.0


func _process(delta):
	# Move the projectile forward
	position += Vector2(MOVE_SPEED * delta, 0.0)
	
	# If the projectile moves beyond the right of our screen we destroy it
	if position.x >= SCREEN_WIDTH + 8:
		queue_free()


func _on_shot_area_entered(area):
	if area.is_in_group("asteroid"):
		# If the projectile hits an asteroid we destroy the projectile
		# Note that the scoring is done in the asteroid script
		queue_free()
