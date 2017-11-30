extends Node

func _init():
	var rotate_matrix = Transform2D().rotated(deg2rad(90)) # rotate 90 degrees
	var scale_matrix = Transform2D().scaled(Vector2(2, 2)) # scale twice in each axis
	var translate_matrix = Transform2D().translated
	var combined_matrix = translate_matrix * rotate_matrix * scale_matrix  # combine the transforms in order
	$my_node.transform *= combined   # apply the transform to a node
