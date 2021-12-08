extends Control

export (float) var textSpeed = 0.05

export (NodePath) var timerPath
export (NodePath) var portraitPath
export (NodePath) var textPath
export (NodePath) var namePath
export (NodePath) var Q1ButtonPath
export (NodePath) var Q2ButtonPath
export (NodePath) var indicatorPath
export (NodePath) var animPath

var dialogPath = "res://Dialogs/SamDialog.json"
var timer: Timer
var nameLabel: RichTextLabel
var textLabel: RichTextLabel
var portrait: Sprite
var Q1Button: Button
var Q2Button: Button
var indicator: Polygon2D 
var anim: AnimationPlayer
var dialog

var phraseNum = 0
var finished = false
var question = false

func _ready():
	_initialize()
	self._initialize_dialog(dialogPath)
	
func _initialize():
	timer = get_node(timerPath)
	nameLabel = get_node(namePath)
	textLabel = get_node(textPath)
	portrait = get_node(portraitPath)
	Q1Button = get_node(Q1ButtonPath)
	Q2Button =  get_node(Q2ButtonPath)
	indicator = get_node(indicatorPath)
	anim = get_node(animPath)
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			phraseNum = int(dialog[phraseNum]["next"])
			nextPhrase()
		else:
			textLabel.visible_characters = len(textLabel.text)
		
func _initialize_dialog(path):
	timer.wait_time = textSpeed
	dialog = getDialog(path)
	assert(dialog, "Dialog not found")
	nextPhrase()
	
func getDialog(path) -> Array:
	var f = File.new()
	assert(f.file_exists(path), "File path does not exist")
	
	f.open(path, File.READ)
	var json = f.get_as_text()
	
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
	
func nextPhrase() -> void:
	if phraseNum >= len(dialog):
		queue_free()
		return 
	
	Q1Button.visible = false
	Q2Button.visible = false
	indicator.visible = false
	finished = false
	
	textLabel.visible_characters = 0
	
	match dialog[phraseNum]["type"]:
		"dialogue":
			textLabel.rect_size = Vector2(778, 120)
			setup("Dialog")
		"question":
			textLabel.rect_size = Vector2(778, 70)
			setup("Question")
			
func setup(option):
	nameLabel.bbcode_text = dialog[phraseNum]["speaker_id"]
	textLabel.bbcode_text = dialog[phraseNum]["text"]
	timer.wait_time = dialog[phraseNum]["text_speed"]
	
	if option == "Question":
		var i = 0
		for key in dialog[phraseNum]["questions"]:
			match i:
				0:
					Q1Button.text = key
				1:
					Q2Button.text = key
			i+= 1

	var f = File.new()
	var img = "res://Images/" + dialog[phraseNum]["speaker_id"] + dialog[phraseNum]["portrait_id"] + ".png"
	if f.file_exists(img):
		portrait.texture = load(img)
	else:
		portrait.texture = null
	
	while textLabel.visible_characters < len(textLabel.text):
		textLabel.visible_characters += 1
		
		timer.start()
		yield(timer, "timeout")
		
	match option:
		"Dialog":
			finished = true
			indicator.visible = true
			anim.play("Bounce")
		"Question":
			Q1Button.visible = true
			Q2Button.visible = true
	
func _on_Q1Button_pressed():
	phraseNum = int(dialog[phraseNum]["questions"][Q1Button.text]["next"])
	nextPhrase()
	
func _on_Q2Button_pressed():
	phraseNum = int(dialog[phraseNum]["questions"][Q1Button.text]["next"])
	nextPhrase()
