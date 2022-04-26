extends Node

export(bool) var debug

var path
var is_moded
var remove = []
var mod_dialogs = []
var mods = []
var num_of_characters = 4

func _ready():
	if debug:
		path = "res://mods"
	else:
		path = "./mods"
	_loadmods()

func _loadmods():
	var dir = Directory.new()
	is_moded = dir.open(path) == OK
	if is_moded:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if ".gd" in file_name:
				mods.append(file_name)
				var path_string = path + "/%s" % file_name
				var file = load(path_string)
				var script = file.new()
				if script.has_method("add_id"):
					mod_dialogs.append_array(script.call("add_id"))
				if script.has_method("remove_id"):
					remove.append_array(script.call("remove_id"))
				if script.has_method("num_of_dialogs"):
					num_of_characters = script.call("num_of_dialogs")
			file_name = dir.get_next()
	else:
		print("No valid mod folder. Valid mod folder name is 'mods'")
