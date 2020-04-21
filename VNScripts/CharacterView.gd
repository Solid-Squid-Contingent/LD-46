extends Node2D

var currentCharacters = []

var characterMap = {
	"christine": preload("res://VNScenes/CharacterScenes/Christine/Christine.tscn"),
	"christine happy": preload("res://VNScenes/CharacterScenes/Christine/ChristineHappy.tscn"),
	"christine sad": preload("res://VNScenes/CharacterScenes/Christine/ChristineSad.tscn"),
	"christine surprised": preload("res://VNScenes/CharacterScenes/Christine/ChristineSurprised.tscn"),
	
	"michael": preload("res://VNScenes/CharacterScenes/Michael/Michael.tscn"),
	"michael happy": preload("res://VNScenes/CharacterScenes/Michael/MichaelHappy.tscn"),
	"michael sad": preload("res://VNScenes/CharacterScenes/Michael/MichaelSad.tscn"),
	"michael surprised": preload("res://VNScenes/CharacterScenes/Michael/MichaelSurprised.tscn"),
	
	"michael old": preload("res://VNScenes/CharacterScenes/MichaelOld/MichaelOld.tscn"),
	"michael old happy": preload("res://VNScenes/CharacterScenes/MichaelOld/MichaelOldHappy.tscn"),
	"michael old sad": preload("res://VNScenes/CharacterScenes/MichaelOld/MichaelOldSad.tscn"),
	"michael old surprised": preload("res://VNScenes/CharacterScenes/MichaelOld/MichaelOldSurprised.tscn"),
	
	"sarah": preload("res://VNScenes/CharacterScenes/Sarah/Sarah.tscn"),
	"sarah happy": preload("res://VNScenes/CharacterScenes/Sarah/SarahHappy.tscn"),
	"sarah sad": preload("res://VNScenes/CharacterScenes/Sarah/SarahSad.tscn"),
	"sarah surprised": preload("res://VNScenes/CharacterScenes/Sarah/SarahSurprised.tscn"),
	
	"sarah old": preload("res://VNScenes/CharacterScenes/SarahOld/SarahOld.tscn"),
	"sarah old happy": preload("res://VNScenes/CharacterScenes/SarahOld/SarahOldHappy.tscn"),
	"sarah old sad": preload("res://VNScenes/CharacterScenes/SarahOld/SarahOldSad.tscn"),
	"sarah old surprised": preload("res://VNScenes/CharacterScenes/SarahOld/SarahOldSurprised.tscn"),
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
	"beach": $BackgroundBeach,
	"deep sea creatures": $BackgroundDeepSeaCreatures,
	"living room night": $BackgroundLivingRoomNight,
	"black": $Black,
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
	for character in listOfCharacters:
		if character.begins_with("lucas"):
			listOfCharacters.erase(character)
			break
	
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
