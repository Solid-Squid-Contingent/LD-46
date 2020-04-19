extends Node2D

var currentCharacters = []

var characterMap = {
	"thief": preload("res://RealElvenThief.tscn"),
	"cat": preload("res://CatDude.tscn")
}

var exampleCharacterList1 = ["thief", "cat"]
var exampleCharacterList2 = ["cat", "thief"]

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
	"thunderstorm": $Background1,
	"field": $Background2,
	"mountain": $Background1
}

export (String) var startingBackground = "field"

# Called when the node enters the scene tree for the first time.
func _ready():
	change_background(startingBackground)
	add_characters(exampleCharacterList1)

func add_characters(listOfCharacters):
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
	add_child(new_character)
	currentCharacters.append(new_character)
	return new_character

func remove_characters():
	for character in currentCharacters:
		remove_child(character)
