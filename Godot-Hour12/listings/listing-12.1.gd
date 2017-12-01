extends Node

func _ready():
	save_config()

func save_config():
	var path = "user://config.ini" # The path to save the file
	var config = ConfigFile.new() # Create a new ConfigFile object
	config.set_value("options", "difficulty", "hard") # Save the game difficulty
	config.set_value("audio", "music_volume", 42) # Save the music volume

	var err = config.save(path) # Save the configuration file to the disk
	if err != OK: # If there's an error
		print("Some error occurred")
