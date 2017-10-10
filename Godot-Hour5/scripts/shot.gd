extends Area2D

const SCREEN_WIDTH = 320
const SPEED = 500.0
const DAMAGE = 1


func _process(delta):
	# Move the projectile forward
	position += Vector2(SPEED * delta, 0.0)

	# If the projectile moves beyond the right of our screen we destroy it
	if position.x >= SCREEN_WIDTH + 16:
		queue_free()
	pass


func _on_shot_area_entered(asteroid):
	# If the projectile hits an asteroid we do damage to the it
	# and destroy the projectile. Note: we know that we hit an asteroid
	# because our Area2D's collision mask is set to asteroid.
	asteroid.do_damage(DAMAGE)
	queue_free()
	pass 
