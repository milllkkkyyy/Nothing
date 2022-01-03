extends Control

export (NodePath) var titleLabelPath
var titleLabel: Label
signal isFinished

func _ready():
	_initialize()
	
func _initialize():
	titleLabel = get_node(titleLabelPath)
	
func present(text):
	titleLabel.text = text
	visible = true

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("isFinished")
