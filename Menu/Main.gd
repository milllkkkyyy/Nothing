extends Control

onready var timer_fade = $FadeOut/Timer
onready var anim = $FadeOut/AnimationPlayer
onready var anim2 = $FadeOut/AnimationPlayer2
onready var fade_rect = $FadeOut/ColorRect2

func _ready():
	var value = Globals.music_volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(value))

func _on_start_pressed():
	fade_rect.visible = true
	timer_fade.start()
	anim.play("Fade_Out")
	anim2.play("Fade_Music")
	
func _on_settings_pressed():
	var s = ResourceLoader.load("res://Settings/Settings.tscn")
	var settings = s.instance()
	get_tree().get_root().add_child(settings)


func _on_Timer_timeout():
	SceneLoader.goto_scene("res://Test/Test.tscn")
