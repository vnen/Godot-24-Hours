extends Node

# Some variables to store
var player_name = "Link"
var player_score = 550

func _ready():
	create_file()

func create_file():
	var path = "user://save.dat"
	# Create a new File object
	var file = File.new()

	# Open the file for writing
	var err = file.open(path, File.WRITE)
	# Simple error checking
	if err != OK:
		print("An error occurred")
		return

	# Store the player data
	file.store_var(player_name)
	file.store_var(player_score)

	# Release the file handle
	file.close()
