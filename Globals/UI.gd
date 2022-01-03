extends Control

onready var button = $CanvasLayer/Button

var in_menu = true

func _on_Button_pressed():
	if not get_tree().paused:
		var s = ResourceLoader.load("res://Settings/Settings.tscn")
		var settings = s.instance()
		get_tree().get_root().add_child(settings)
		get_tree().paused = true
	
