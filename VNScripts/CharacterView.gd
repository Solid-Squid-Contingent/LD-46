extends Node2D

var currentCharacters = []

var characterMap = {
	"christine": preload("res://VNScenes/CharacterScenes/Christine.tscn"),
	"michael": preload("res://VNScenes/CharacterScenes/Michael.tscn"),
	"michael old": preload("res://VNScenes/CharacterScenes/MichaelOld.tscn"),
	"sarah": preload("res://VNScenes/CharacterScenes/Sarah.tscn"),
	"sarah old": preload("res://VNScenes/CharacterScenes/SarahOld.tscn")
}

onready var positions = [
	[
		#positions[0][0]
		$"1CharacterPosition1".position
	],
	[
		#positions[1][0]
		$"2CharacterPosition1".position,
		#positions[1][1]
		$"2CharacterPosition2".position,
	]
]

onready var backgroundMap = {
	"city": $BackgroundCity,
	"class": $BackgroundClass,
	"deep sea": $BackgroundDeepSea,
	"deep sea eye": $BackgroundDeepSeaEye,
	"living room": $BackgroundLivingRoom,
	"office": $BackgroundOffice,
	"shallow sea": $BackgroundShallowSea,
	"shallow sea creatures": $BackgroundShallowSeaCreatures,
}

onready var foremostBackground = $BackgroundShallowSeaCreatures

export (String) var startingBackground = "field"

# Called when the node enters the scene tree for the first time.
func _ready():
	change_background(startingBackground)

func add_characters(listOfCharacters):
	#TODO: Remove if we get lucas sprites
	listOfCharacters.erase("lucas young")
	listOfCharacters.erase("lucas")
	listOfCharacters.erase("lucas old")
	
	for index in range(listOfCharacters.size()):
		var character = add_character(listOfCharacters[index], positions[listOfCharacters.size() - 1][index])
		if index % 2 == 1:
			flip_character(character)

func turn_off_backgrounds():
	for background in backgroundMap:
		backgroundMap[background].visible = false

func change_background(newBackground: String):
	turn_off_backgrounds()
	backgroundMap[newBackground].visible = true

func flip_character(character):
	character.get_node("Sprite").flip_h = true

func add_character(character: String, position):
	var new_character = characterMap[character].instance()
	new_character.position = position
	add_child_below_node(foremostBackground, new_character)
	currentCharacters.append(new_character)
	return new_character

func remove_characters():
	for character in currentCharacters:
		character.queue_free()
	currentCharacters.clear()


func _on_DialogManager_change_background(background):
	change_background(background)


func _on_DialogManager_change_characters(characters):
	remove_characters()
	add_characters(characters)
