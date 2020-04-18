extends Node2D

signal switch_to_sick
signal switch_to_pet
signal tamagotchi_died

var age: float = 0
var stage: int = 0

var fullness: float = 100
var awakeness: float = 100
var fun: float = 100
var happiness: float = 100

onready var fullProgressBar = $UIContainer/FullnessUI/TextureProgress
onready var awakeProgressBar = $UIContainer/AwakenessUI/TextureProgress
onready var funProgressBar = $UIContainer/FunUI/TextureProgress
onready var petHappyProgressBar = $UIContainer/PetHappinessUI/TextureProgress
onready var sickHappyProgressBar = $UIContainer/SickHappinessUI/TextureProgress

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("switch_to_pet")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fullness -= delta
	awakeness -= delta
	fun -= delta
	happiness -= delta
	
	if fullness <= 0 or awakeness <= 0 or fun <= 0 or happiness <= 0:
		die()
	
	age += delta
	
	if stage < 2 and age > 100:
		age_up()
		age = 0
	
	fullProgressBar.value = fullness
	awakeProgressBar.value = awakeness
	funProgressBar.value = fun
	petHappyProgressBar.value = happiness
	sickHappyProgressBar.value = happiness

func die() -> void:
	emit_signal("tamagotchi_died")

func age_up() -> void:
	stage += 1
	if (stage == 2):
		emit_signal("switch_to_sick")
	
func is_satisfied(need) -> bool:
	if need == 100:
		return true
	return false

func _on_FoodButton_pressed() -> void:
	if is_satisfied(fullness):
		#play nono animation
		pass
	else:
		fullness = fullness + 10

func _on_SleepButton_pressed():
	if is_satisfied(awakeness):
		#play nono animation
		pass
	else:
		awakeness = awakeness + 10


func _on_PlayButton_pressed():
	if is_satisfied(fun):
		#play nono animation
		pass
	else:
		fun = fun + 10


func _on_ExtraButton_pressed():
	if is_satisfied(happiness):
		#play nono animation
		pass
	else:
		happiness = happiness + 10
