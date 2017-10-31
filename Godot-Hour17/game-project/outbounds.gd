extends Area

func _on_Inbounds_area_exited( area ):
	var body = area.get_parent()
	var parent = body.get_parent()
	if parent.won or parent.respawning: return
	body.gravity_scale = 1
	parent.lose()
	body.angular_velocity *= 2
