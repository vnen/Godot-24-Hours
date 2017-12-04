extends Sprite

func finished_move_left():
	$AnimationTreePlayer.transition_node_set_current("transition", 1)

func finished_move_right():
	$AnimationTreePlayer.transition_node_set_current("transition", 0)

func _input(event):
	if event is InputEventKey:
		# when up ARROW is pressed, set transition time to a random value
		if(event.scancode == KEY_UP && event.pressed == false):
			$AnimationTreePlayer.transition_node_set_xfade_time("transition", rand_range(0.1,2.0))
