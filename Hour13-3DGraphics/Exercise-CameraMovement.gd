extends Camera

func _input(event):
	var SPEED = 1
	if event is InputEventKey:
		# when up ARROW is pressed
		if(event.scancode == KEY_UP):
			set_translation(get_translation() + Vector3(0,0,-SPEED))
			
		# when down ARROW is pressed
		if(event.scancode == KEY_DOWN):
			set_translation(get_translation() + Vector3(0,0,SPEED))
			
		# when left ARROW is pressed
		if(event.scancode == KEY_LEFT):
			set_translation(get_translation() + Vector3(-SPEED,0,0))
			
		# when right ARROW is pressed
		if(event.scancode == KEY_RIGHT):
			set_translation(get_translation() + Vector3(SPEED,0,0))
	elif event is InputEventMouseButton:
		# when the user SCROLLS
		if event.button_index == BUTTON_WHEEL_UP:
			set_perspective(get_fov()+1, 0.1, 1000)
		elif event.button_index == BUTTON_WHEEL_DOWN:
			set_perspective(get_fov()-1, 0.1, 1000)

