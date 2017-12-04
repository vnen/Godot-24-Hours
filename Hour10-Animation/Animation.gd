extends Sprite

# if no animation is playing, just do the walking animation again
func _process(delta):
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("walking")

# when the UP arrow key is pressed, play the jumping animation
func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_UP && event.pressed == false:
			$AnimationPlayer.play("Jumping")

# a signal fired from within an animation
func wood_chop():
	print("Yay!")