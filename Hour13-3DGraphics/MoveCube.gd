extends Spatial

# code for manually positioning the camera to follow the cube
func _process(delta):
	$Camera.set_translation($Cube.get_translation() + Vector3(0, 25, 25)) # offset the camera from the cube
	$Camera.set_rotation(Vector3(-45,0,0)) # rotate it so it faces the cube
	$Cube.set_translation($Cube.get_translation() + Vector3(1, 0, -1))