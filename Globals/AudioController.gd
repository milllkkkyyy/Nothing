extends Node2D

export(NodePath) var audio_music_path
export(NodePath) var audio_sfx_path
export(NodePath) var tween_path

var music : AudioStreamPlayer
var sfx : AudioStreamPlayer
var tween : Tween

var is_fading_out = false
var music_vol = 0
var sfx_vol = 0

func _ready():
	_initialize()

func _initialize():
	music = get_node(audio_music_path)
	sfx = get_node(audio_sfx_path)
	tween = get_node(tween_path)

func fade_out_audio(stream_player, duration = 1.0):
	#ignore warning. Tween methods returns basically nothing. 
	var current_vol = stream_player.volume_db
	tween.interpolate_property(stream_player, "volume_db", current_vol, -80, duration, 1, Tween.EASE_IN, 0)
	tween.start()
	is_fading_out = true

func fade_in_audio(stream_player, duration = 1.0):
	var final_volume = 0
	if stream_player.bus == "SFX":
		final_volume = sfx_vol
	else:
		final_volume = music_vol
	tween.interpolate_property(stream_player, "volume_db", -80, final_volume, duration, 1, Tween.EASE_IN, 0)
	tween.start()

func play_all():
	music.play()
	sfx.play()
	
func stop_all():
	music.playing = false
	sfx.playing = false
	
func play_music():
	music.play()

func play_sfx():
	sfx.play()

func stop_music():
	music.playing = false

func stop_sfx():
	sfx.playing = false

func set_music(stream):
	music.stream = stream
	
func set_sfx(stream):
	sfx.stream = stream

func set_music_db(value):
	music.volume_db = value
	music_vol = value
	
func set_sfx_db(value):
	sfx.volume_db = value
	sfx_vol = value
	
func is_music_playing():
	return music.playing

func is_sfx_playing():
	return sfx.playing

func _on_Tween_tween_completed(object, _key):
	if object == sfx:
		if is_fading_out:
			self.stop_sfx()
			self.set_sfx_db(0)
		is_fading_out = false
	if object == music:
		if is_fading_out:
			self.stop_music()
			self.set_music_db(0)
		is_fading_out = false
		
