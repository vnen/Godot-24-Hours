extends Sprite

func _input(event):
	if event is InputEventKey:
		# when up ARROW is pressed, transition (in 0.2s) to the other animation
		if(event.scancode == KEY_UP && event.pressed == false):
			$AnimationTreePlayer.transition_node_set_xfade_time("transition", 0.2)
			$AnimationTreePlayer.transition_node_set_current("transition",1)
			
			# code for turning on/off the animation tree player
#			if($AnimationTreePlayer.is_active()):
#				$AnimationTreePlayer.set_active(false)
#			else:
#				$AnimationTreePlayer.set_active(true)
