extends Node

var noshard = 0
var memshard = 0

var inv = {
	'shovel': 0
}

@export var noshard_map: Dictionary = {
	1: "res://scenes/levels/memory_1.tscn",
	2: "res://scenes/levels/memory_2.tscn"
}

@export var memshard_map: Dictionary = {
	1: "res://scenes/levels/level_2.tscn"
	
}

func tp_no():
	var scene_path = noshard_map.get(noshard, "")
	if scene_path == "":
	
		return
	_load_map(scene_path)

func tp_mem():
	var scene_path = memshard_map.get(memshard, "")
	if scene_path == "":
		return
	
	_load_map(scene_path)

func _load_map(scene_path: String):
	get_tree().change_scene_to_file(scene_path)
	
