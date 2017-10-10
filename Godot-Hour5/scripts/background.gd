extends Sprite

const SCREEN_WIDTH = 320

# Defines how fast the background will move (in pixels per second)
var speed = 30.0


func _process(delta):
	
	# Move the background a little bit to the left
	position += Vector2(-speed * delta, 0.0)
	
	# If we move beyond the left of our screen just place us back to the 
	# right of our screen
	if position.x <= -SCREEN_WIDTH:
		position.x += 2 * SCREEN_WIDTH
	pass
