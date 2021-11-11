extends Control

export(NodePath) var volume_slider_path

var volume_slider : HSlider

func _ready():
	volume_slider = get_node(volume_slider_path)
	volume_slider.value = Globals.music_volume

func _on_Return_pressed():
	self.queue_free()

func _on_Volume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(value))
	Globals.music_volume = value
