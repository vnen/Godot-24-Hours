extends KinematicBody2D

# The speed in pixels per second
export (float) var speed = 100.0

# Run this function in a synchrony with physics processing
func _physics_process(delta):
	# Calculate the direction vector based on input
	var direction = Vector2()
	if Input.is_action_pressed("ui_left"):
		direction.x = -1
	elif Input.is_action_pressed("ui_right"):
		direction.x = 1
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
	elif Input.is_action_pressed("ui_down"):
		direction.y = 1

	# Normalize the movement vector and modulate by the speed
	var movement = direction.normalized() * speed

	# Move the body based on the calculated speed and direction
	move_and_slide(movement)
