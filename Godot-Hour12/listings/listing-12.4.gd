extends Node

func _ready():
	read_file()

func read_file():
	var path = "user://save.dat"
	# Create a new File object
	var file = File.new()

	# Open the file for reading
	var err = file.open(path, File.READ)
	# Simple error checking
	if err != OK:
		print("An error occurred")
		return

	var read = {}
	read.player_name = file.get_var()
	read.player_score = file.get_var()

	file.close()

	return read
