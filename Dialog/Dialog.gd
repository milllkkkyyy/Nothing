extends Control

export (float) var textSpeed = 0.05

export (NodePath) var timerPath
export (NodePath) var inputDelayPath
export (NodePath) var portraitPath
export (NodePath) var textPath
export (NodePath) var namePath
export (NodePath) var Q1ButtonPath
export (NodePath) var Q2ButtonPath
export (NodePath) var indicatorPath
export (NodePath) var indicatorAnimPath
export (NodePath) var loadAnimPath
export (NodePath) var colorRectPath

var dialogPath = ""
var timer: Timer
var inputDelay: Timer
var nameLabel: RichTextLabel
var textLabel: RichTextLabel
var portrait: TextureRect
var Q1Button: Button
var Q2Button: Button
var indicator: Polygon2D 
var indicatorAnim: AnimationPlayer
var loadAnim: AnimationPlayer
var colorRect: ColorRect
var dialog

var phraseNum = 0
var finished = false
var question = false

signal isFinished 

var command
var unlocked_questions = false

func _ready():
	_initialize()
	
func _initialize():
	timer = get_node(timerPath)
	nameLabel = get_node(namePath)
	textLabel = get_node(textPath)
	portrait = get_node(portraitPath)
	Q1Button = get_node(Q1ButtonPath)
	Q2Button =  get_node(Q2ButtonPath)
	indicator = get_node(indicatorPath)
	indicatorAnim = get_node(indicatorAnimPath)
	colorRect = get_node(colorRectPath)
	inputDelay = get_node(inputDelayPath)
	loadAnim = get_node(loadAnimPath)
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and inputDelay.is_stopped():
		if finished:
			phraseNum = int(dialog[phraseNum]["next"])
			nextPhrase()
			inputDelay.start()
		else:
			textLabel.visible_characters = len(textLabel.text)
		
func initialize_dialog(path):
	visible = true
	set_button_visibility(true)
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
		emit_signal("isFinished")
		return 
	
	indicator.visible = false
	finished = false
	
	textLabel.visible_characters = 0
	
	match dialog[phraseNum]["type"]:
		"dialogue":
			setup("dialog")
		"question":
			setup("question")
			
func setup(option):
	nameLabel.text = dialog[phraseNum]["speaker_id"]
	textLabel.text = dialog[phraseNum]["text"]
	timer.wait_time = dialog[phraseNum]["text_speed"]
	colorRect.color = Color(dialog[phraseNum]["bg_color"])
	
	if dialog[phraseNum].has("command"):
		process_command(dialog[phraseNum]["command"])
	
	if option == "question":
		
		var i = 0
		for answer in dialog[phraseNum][question_type()]:
			match i:
				0:
					Q1Button.text = answer
				1:
					Q2Button.text = answer
			i+= 1
	var img
	if dialog[phraseNum]["speaker_id"] in ModLoader.mod_dialogs:
		img = ModLoader.path + "/" + dialog[phraseNum]["speaker_id"] + dialog[phraseNum]["portrait_id"] + ".png"
	else:
		img = "res://Images/Characters/" + dialog[phraseNum]["speaker_id"] + "/" + dialog[phraseNum]["portrait_id"] + ".png"
	portrait.texture = load(img)
	
	while textLabel.visible_characters < len(textLabel.text):
		textLabel.visible_characters += 1
		
		timer.start()
		yield(timer, "timeout")
		
	match option:
		"dialog":
			finished = true
			indicator.visible = true
			indicatorAnim.play("Bounce")
		"question":
			set_button_visibility(false)
	
func process_command(c):
	if c == "unlocked_questions":
		unlocked_questions = true

func question_type():
	if dialog[phraseNum].has("unlocked_questions") and unlocked_questions:
		return "unlocked_questions"
	return "questions"

func _on_Q1Button_pressed():
	phraseNum = int(dialog[phraseNum][question_type()][Q1Button.text])
	set_button_visibility(true)
	nextPhrase()
	
func _on_Q2Button_pressed():
	phraseNum = int(dialog[phraseNum][question_type()][Q2Button.text])
	set_button_visibility(true)
	nextPhrase()

func set_button_visibility(are_visible):
	Q1Button.disabled = are_visible
	Q2Button.disabled = are_visible
	Q1Button.visible = !are_visible
	Q2Button.visible = !are_visible
