extends Control

export(NodePath) var music_slider_path
export(NodePath) var sfx_slider_path
export(NodePath) var sprite_return_path
export(NodePath) var button_return_path

var music_slider : HSlider
var sfx_slider : HSlider
var sprite_return : AnimatedSprite
var button_return : Button

func _ready():
	_initialize()
	music_slider.value = Globals.music_volume
	sfx_slider.value = Globals.sfx_volume

func _initialize():
	music_slider = get_node(music_slider_path)
	sfx_slider = get_node(sfx_slider_path)
	sprite_return = get_node(sprite_return_path)
	button_return = get_node(button_return_path)

func _on_Return_pressed():
	get_tree().paused = false
	self.queue_free()

func _on_Music_value_changed(value):
	var bus_idx = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_idx, linear2db(value))
	Globals.music_volume = value

func _on_Return_mouse_entered():
	button_return.text = ""
	sprite_return.playing = true
	sprite_return.visible = true


func _on_Return_mouse_exited():
	button_return.text = "RETURN"
	sprite_return.playing = false
	sprite_return.visible = false

func _on_SFX_value_changed(value):
	var bus_idx = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_idx, linear2db(value))
	Globals.sfx_volume = value
