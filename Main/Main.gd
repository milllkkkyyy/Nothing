extends Node2D

var music = preload("res://Audio/Music/listen.ogg")
var sfx_pre = preload("res://Audio/SFX/talking.ogg")
var sfx_post = preload("res://Audio/SFX/talking_post.ogg")

const dialog_path = "res://Dialog/Dialog.tscn"
const titleCard_path = "res://Extra/TitleCard.tscn"
const storyBoard_path = "res://Extra/StoryCard.tscn" 

# the list of built in available dialogs
const dialogs = ["Lucy", "Harry", "Anne", "Book", 
"Francis", "Larry", "Ben", "Felix"]

var dialogs_pre = []
var dialogs_post = []

var daves_sayings = [
	"NEXT GIRLIES!",
	"LETS GO NEXT!",
	"NOT YOU CATCHING FEELINGS!",
	"WRAP IT UP FELLAS!",
	"NEXT!",
	"DONT THINK HES THE ONE HONEY!",
	"MILLONS OF FISH IN THE SEA!",
	"COME ON WRAP IT UP!"
]

func _ready():
	AudioController.stop_sfx()
	
	Ui.button.visible = true
	Ui.button.disabled = false
	var path = "res://Dialogs/DavePreIntro.json"
	var intro = present_dialog(path)
	
	AudioController.set_sfx(sfx_pre)
	AudioController.set_sfx_db(-15)
	
	AudioController.play_sfx()
	AudioController.fade_in_audio(AudioController.sfx)
	
	randomize()
	var temp = dialogs + ModLoader.mod_dialogs
	
	for character in ModLoader.remove:
		if character in temp:
			temp.remove(character)
		
	for _i in range(ModLoader.num_of_characters):
		var index = randi() % len(temp)
		var item = temp[index]
		temp.remove(index)
		dialogs_pre.append(item)
		
	yield(intro, "isFinished")
	intro.queue_free()
	
	var text = "OKAY TIME TO START"
	var title = present_titleCard(text)
	yield(title, "isFinished")
	title.queue_free()
	
	pre_game()
	pass
	
func pre_game():
	while dialogs_pre:
		var top = dialogs_pre.pop_back()
		var path
		if top in dialogs:
			path = "res://Dialogs/" + top + "PreDialog.json"
		else:
			path = ModLoader.path + "/" + top + "PreDialog.json"
		var dialog = present_dialog(path)
		dialogs_post.append(top)
		yield(dialog, "isFinished")
		dialog.queue_free()
		
		var text = daves_sayings[randi() % len(daves_sayings)]
		var title = present_titleCard(text)
		yield(title, "isFinished")
		title.queue_free()
		
	var text = "ALL FINISHED!"
	var title = present_titleCard(text)
	yield(title, "isFinished")
	title.queue_free()
	
	intermission()

func intermission():
	
	AudioController.fade_out_audio(AudioController.music)
	AudioController.fade_out_audio(AudioController.sfx)
	
	var story = present_storyBoard()
	yield(story, "isFinished")
	story.queue_free()
	
	AudioController.set_sfx(sfx_post)
	AudioController.set_sfx_db(-20)
	AudioController.set_music(music)
	AudioController.set_music_db(-20)
	
	AudioController.play_music()
	AudioController.fade_in_audio(AudioController.music)
	AudioController.play_sfx()
	AudioController.fade_in_audio(AudioController.sfx)
	
	var path = "res://Dialogs/DavePostIntro.json"
	var intro = present_dialog(path)
	yield(intro, "isFinished")
	intro.queue_free()
	
	post_game()
	
func post_game():
	while dialogs_post:
		var top = dialogs_post.pop_back()
		var path
		if top in dialogs:
			path = "res://Dialogs/" + top + "PostDialog.json"
		else:
			path = ModLoader.path + "/" + top + "PostDialog.json"
		var dialog = present_dialog(path)
		yield(dialog, "isFinished")
		dialog.queue_free()
	
	AudioController.fade_out_audio(AudioController.music)
	
	var text = "I hope everyone has a good life"
	var title = present_titleCard(text)
	yield(title, "isFinished")
	title.queue_free()
	finished()
	
func finished():
	SceneLoader.goto_scene("res://Menu/Main.tscn")

func present_storyBoard():
	var storyCard = start_scene(storyBoard_path)
	return storyCard
	
func present_dialog(path):
	var dialog = start_scene(dialog_path)
	dialog.initialize_dialog(path)
	return dialog
	
func present_titleCard(text):
	var titleCard = start_scene(titleCard_path)
	titleCard.present(text)
	return titleCard

func start_scene(path):
	var s = ResourceLoader.load(path)
	var scene = s.instance()
	get_tree().get_root().add_child(scene)
	return scene
