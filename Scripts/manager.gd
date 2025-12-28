extends Node

var scene = preload("res://Scenes/title.tscn")

func _init() -> void:
	var obj = scene.instantiate()
	add_child(obj)
