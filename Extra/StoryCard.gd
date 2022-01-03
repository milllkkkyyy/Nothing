extends Control

const story = [
	
	"[center]After this very day a pandemic hit the world.[/center]",
	"[center]It happened so quickly no one could even process it[/center]",
	"[center]The pandemic ravaged families and communities.[/center]",
	"[center]The year didnt feel real. it felt like Nothing.[/center]",
	"[center]You decided to go to the reuinion, which was hosted after everything settled down.[/center]"
	
]

export (NodePath) var textPath
export (NodePath) var labelPath

var text: RichTextLabel
var label: Label

var index = 0
signal isFinished

func _ready():
	_initialize()
	present(index)
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		index += 1
		if index < len(story):
			present(index)
		else:
			emit_signal("isFinished")

func _initialize():
	text = get_node(textPath)
	label = get_node(labelPath)
		
func present(next):
	text.bbcode_text = story[next]
