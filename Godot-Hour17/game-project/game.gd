extends Spatial

var current_level = null

func _ready():
	next_level()

func _on_Block_won():
	$LevelLoad.start()

func next_level():
	var next_level = Levels.get_next_level()
	if next_level == "":
		return

	if current_level != null:
		current_level.queue_free()

	current_level = load(next_level).instance()
	add_child(current_level)

	$Block.start_point = str($Block.get_path_to(current_level)) + "/Start"
	$Block.respawn()
