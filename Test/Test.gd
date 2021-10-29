extends Node2D

onready var bg_sprite = $Background
onready var sam_sprite = $Sam
onready var anim = $AnimationPlayer

var chat = load("res://Test/Images/chat_mouse_64.png")
var def = load("res://Test/Images/default_mouse_64.png")
var interact = load("res://Test/Images/interact_mouse_64.png")

const BUTTONLEFT = 1

func _ready():
	Input.set_custom_mouse_cursor(def)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTONLEFT:
		var new_dialog = Dialogic.start('sam_test', 'def')
		add_child(new_dialog)

func _on_Area2D_mouse_entered():
	anim.play("fade_bg")
	Input.set_custom_mouse_cursor(chat)

func _on_Area2D_mouse_exited():
	anim.play_backwards("fade_bg")
	Input.set_custom_mouse_cursor(def)
