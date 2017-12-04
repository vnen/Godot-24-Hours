extends Spatial

func _ready():
	for i in range(0,20):
		for j in range(0,20):
			if(rand_range(0,1) > 0.5):
				var newBuilding = MeshInstance.new();
				newBuilding.set_mesh(CubeMesh.new());
				add_child(newBuilding)
				
				newBuilding.set_translation(Vector3(i*4, 0, j*4))
				newBuilding.set_scale(Vector3(rand_range(0.5,1.5), rand_range(0.5, 3), rand_range(0.5, 1.5)))
