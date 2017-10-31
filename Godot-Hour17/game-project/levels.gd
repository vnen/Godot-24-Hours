extends Node

signal levels_ended()

const levels_path = "res://levels"

var level_list = []
var current_level

func _enter_tree():
	var dir = Directory.new()

	dir.open(levels_path)
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		if file == "." or file == "..":
			file = dir.get_next()
			continue
		level_list.push_back(levels_path.plus_file(file))
		file = dir.get_next()

	level_list.sort()
	current_level = -1

func get_next_level():
	current_level += 1
	if current_level == level_list.size():
		emit_signal("levels_ended")
		return ""
	return level_list[current_level]
