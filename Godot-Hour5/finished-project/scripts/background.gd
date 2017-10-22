extends Sprite

const SCREEN_WIDTH = 320

# Defines how fast the background will move (in pixels per second)
var scroll_speed = 30.0


func _process(delta):
	
	# Move the background a little bit to the left
	position += Vector2(-scroll_speed * delta, 0.0)
	
	# If we move one full screenwidth beyond the left of our screen 
	# just place us back one full screenwidth to the right.
	# This creates the illusion of a infinitely scrolling background 
	if position.x <= -SCREEN_WIDTH:
		position.x += SCREEN_WIDTH
