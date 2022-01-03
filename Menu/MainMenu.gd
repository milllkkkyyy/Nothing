extends Control

export(NodePath) var timer_fade_path
export(NodePath) var button_start_path
export(NodePath) var button_settings_path
export(NodePath) var sprite_settings_path
export(NodePath) var sprite_start_path

var music = preload("res://Audio/Music/luvtea.ogg")
var sfx = preload("res://Audio/SFX/bird_noises.ogg")

var sprite_settings : AnimatedSprite
var sprite_start : AnimatedSprite
var button_start : Button
var button_settings : Button

var clicked_button = false

func _ready():
	get_tree().paused = false
	Ui.in_menu = true
	Ui.button.visible = false
	Ui.button.disabled = true
	_initialize()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(Globals.music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(Globals.sfx_volume))

func _initialize():
	sprite_settings = get_node(sprite_settings_path)
	sprite_start = get_node(sprite_start_path)
	button_start = get_node(button_start_path)
	button_settings = get_node(button_settings_path)
	
	var leaves = get_tree().get_nodes_in_group("leaves")
	for leaf in leaves:
		leaf.emitting = true
		
	AudioController.set_music(music)
	AudioController.set_music_db(-20)
	AudioController.set_sfx(sfx)
	AudioController.set_sfx_db(-30)
	AudioController.play_all()
	
func _on_start_pressed():
	if not clicked_button:
		clicked_button = true
		Ui.in_menu = false
		SceneLoader.goto_scene("res://Main/Main.tscn")
		
func _on_settings_pressed():
	if not get_tree().paused:
		var s = ResourceLoader.load("res://Settings/Settings.tscn")
		var settings = s.instance()
		get_tree().get_root().add_child(settings)
		get_tree().paused = true

func _on_start_mouse_entered():
	button_start.text = ""
	sprite_start.playing = true
	sprite_start.visible = true

func _on_start_mouse_exited():
	button_start.text = "START NEW GAME"
	sprite_start.playing = false
	sprite_start.visible = false

func _on_settings_mouse_entered():
	button_settings.text = ""
	sprite_settings.playing = true
	sprite_settings.visible = true

func _on_settings_mouse_exited():
	button_settings.text = "SETTINGS"
	sprite_settings.playing = false
	sprite_settings.visible =false
