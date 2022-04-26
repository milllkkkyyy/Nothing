# Modding

## What You Need

I am assuming with this you have a starting level of knowlege of how coding works. You can use Notepad to do much of the coding for the mods. I would recommend Visual Studio Code, as it makes error checking and the entire process 100x easier.

## Creating A New Character

To create a character you will need dialogs which will be formatted it into a .json file. This is used so the game is able to process the conversation.

You will need two files for each character:\
[NAME]PreDialog.json\
[NAME]PostDialog.json 

in the dialog jsons itself there are two types of speech. One is dialogue:
```
[
    {
        "type": "dialogue",
        "speaker_id": "Dave",
        "portrait_id": "Happy",
        "text": "Welcome to the reunion for the speed dating event.",
        "next": 1,
        "bg_color": "ffffff",
        "text_speed": 0.03,
        "_index": 0
    }, 
    {
        "type": "dialogue",
        "speaker_id": "Dave",
        "portrait_id": "Normal",
        "text": "HELLO!.",
        "next": 2,
        "bg_color": "ffffff",
        "text_speed": 0.03,
        "_index": 1
    },
]
```
The other is question:
```
[
  {
        "type": "question",
        "speaker_id": "Anne",
        "portrait_id": "Normal",
        "text": "hey.",
        "questions": {
            "how are you doing": 2,
            "hey again": 1
        },
        "bg_color": "e7eb70",
        "text_speed": 0.03,
        "_index": 0
  },
  {
        "type": "dialogue",
        "speaker_id": "Anne",
        "portrait_id": "Happy",
        "text": "Sup.",
        "next": 3,
        "bg_color": "e7eb70",
        "text_speed": 0.03,
        "_index": 1
    }, 
    {
        "type": "dialogue",
        "speaker_id": "Anee",
        "portrait_id": "Normal",
        "text": "I am alright thanks.",
        "next": 3,
        "bg_color": "e7eb70",
        "text_speed": 0.03,
        "_index": 2
    },
]
```
### Key Explaination

"type" can either be "dialogue" or "question"\
"speaker_id" is your characters name capatalized the same way the pictures are.\
"portrait_id" is the facial expression they will have. Each one of these you do you have to draw a seprate image for each of them.\
Name the images in the format [NAME][PORTRAIT_ID].png\
The image size limit is 380 x 658\
"text" is the text the character will say\
"next" is the index of the next dialog (ONLY FOR DIALOGUE)\
"questions" holds a dictionary with format "Button text" : next index (ONLY FOR QUESTIONS)\
"bg_color" hex color code for the characters background\
"text_speed" words per second\
"\_index" parameter for keeping track of the index

### Importing Character / Other usefull tools

Once you have a post-dialog and pre-dialog filled out, and images corresponding to each emotion, we need to import the character.

To import, open a text editor. Notepad will do, and type: 

```
func add_id():
  return [ "NAME OF CHARACTER" + "OTHER NAME OF CHARACTER" + "ETC." ]
```
Save as a .gd file and drag that file and your occompanying files into the mods folder. That should be all you need. If you have done everything correctly you should be able to play your character now / see your mod in the corner of the game in settings. 

If you do not include the .gd file your character will not show up.

#### Other functions

```
func remove_id():
  return [ "NAME OF CHARACTER" + "OTHER NAME OF CHARACTER" + "ETC." ]
```
This function is useful for removing characters from a mod / removing the original cast and putting in a new one.

```
func num_of_dialogs():
  return int
```
This function can be used to set the number of dialogs. If there is more dialogs than possible dialogs the game will crash.

Put these functions in a .gd script and in the mods folder and you can see your mod in the corner of the game.

# Play with mods

Create a folder called "mods" right next to your .exe of NOTHING and then import all of the mods into the folder. Mods cannot be seperated by folders.

# Visual Updates

NOTHING 0.0.01 TESTING DIALOGIC, BASIC SETUP
https://youtu.be/Y7ldXWJRlR4

NOTHING 0.0.02 TESTING MENU DESIGN
https://youtu.be/y96HS7VshHA

NOTHING 0.0.03 FINISHED MENU DESIGN, STARTED CHAPTER ONE WORK
https://youtu.be/QgAGm-fepTA

NOTHING 0.0.04 AUDIOCONTROLLER CLASS
https://youtu.be/3TPhwugoP1U

NOTHING 0.0.05 FIRST SCENE WORKFLOW, ADDED SKIPPABLE CUTSCENES 
https://youtu.be/tbwO2r-6zIQ

NOTHING 0.0.10 FINISHED MENU, DIALOG
https://youtu.be/8oOMU2X_a1g

NOTHING 0.1.0 EARLY ACCESS REALEASE
https://machiteastudios.itch.io/nothing

NOTHING 0.1.0+ UPDATES ARE ON ITCH.IO
https://machiteastudios.itch.io/nothing

# What do you need to run this project
Godot game engine:
https://godotengine.org/
