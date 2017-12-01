extends Node

func _ready():
	print(load_config()) # Should do something meaningful, but let's print for test purposes

func load_config():
	var path = "user://config.ini" # The path to load the file
	var config = ConfigFile.new() # Create a new ConfigFile object

	var default_options = {   # Create a dictionary of default options
		"difficulty": "easy",
		"music_volume": 80
	}

	var err = config.load(path) # Load the file from the disk
	if err != OK: # If there's an error return the default options
		return default_options

	var options = {} # Create a dictionary to store the loaded options

	# Get the values from the file or the predefined defaults if missing
	options.difficulty = config.get_value("options", "difficulty", default_options.difficulty)
	options.music_volume = config.get_value("audio", "music_volume", default_options.music_volume)

	return options # Return the loaded options
