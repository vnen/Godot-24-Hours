extends Particles2D

func _input(event):
	if event is InputEventMouseMotion:
		set_position(get_viewport().get_mouse_position())
