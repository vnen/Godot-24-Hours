extends Node

func _ready():
	# Create a new directory object
	var dir = Directory.new()

	var err = dir.open("res://")
	if err != OK:
		print("An error occurred")
		return

	# Start listing the directories
	dir.list_dir_begin()
	# Retrieve the first file or dir
	var name = dir.get_next()
	# Start a loop
	while name != "":
		# Test if it's a dir and print as appropriate
		if dir.current_is_dir():
			print("dir : ", name)
		else:
			print("file: ", name)

		name = dir.get_next()

	# End the listing
	dir.list_dir_end()
