extends Control

export(NodePath) var anim_path 
export(NodePath) var anim_fade_path
export(NodePath) var timer_fade_path

var anim : AnimationPlayer
var anim_fade : AnimationPlayer
var timer_fade : Timer

var BUTTONLEFT = 1
var finished_setup = false
var skipped_intro = false
var skipped_outtro = false

func _ready():
	_initialize()
	anim_fade.play("Fade")
	timer_fade.start()
	
func _initialize():
	anim = get_node(anim_path)
	anim_fade = get_node(anim_fade_path)
	timer_fade = get_node(timer_fade_path)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if finished_setup and skipped_intro:
			anim.stop()
			anim.play("ExitScene")
			skipped_intro = false
		elif not skipped_intro and not finished_setup:
			anim.advance(10)
		elif finished_setup and not skipped_intro and not skipped_outtro:
			anim.advance(10)

func _on_Timer_timeout():
	anim.play("TextPopUp")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "TextPopUp":
		anim.play("Continue")
		finished_setup = true
		skipped_intro = true
	if anim_name == "ExitScene":
		SceneLoader.goto_scene("res://ChapterOne/SceneOne.tscn")
		skipped_outtro = true
