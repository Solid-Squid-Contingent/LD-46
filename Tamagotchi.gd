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

export(float) var needGain = 10

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
	reduce_all_needs(delta * 2)
	
	age += delta
	if stage < 2 and age > 100:
		age_up()
		age = 0

func reduce_fullness(amount):
	fullness -= amount
	fullProgressBar.value = fullness
	die_if_dead()

func reduce_awakeness(amount):
	awakeness -= amount
	awakeProgressBar.value = awakeness
	die_if_dead()

func reduce_fun(amount):
	fun -= amount
	funProgressBar.value = fun
	die_if_dead()

func reduce_happiness(amount):
	happiness -= amount
	petHappyProgressBar.value = happiness
	sickHappyProgressBar.value = happiness
	die_if_dead()

func reduce_all_needs(amount):
	reduce_fullness(amount)
	reduce_awakeness(amount)
	reduce_fun(amount)
	reduce_happiness(amount)

func die_if_dead():
	if fullness <= 0 or awakeness <= 0 or fun <= 0 or happiness <= 0:
		die()
	
func die():
	emit_signal("tamagotchi_died")

func age_up():
	stage += 1
	if (stage == 2):
		emit_signal("switch_to_sick")
	
func is_satisfied(need) -> bool:
	if need >= 100:
		return true
	return false

func _on_FoodButton_pressed():
	if is_satisfied(fullness):
		#play nono animation
		pass
	else:
		fullness = min(fullness + needGain, 100)

func _on_SleepButton_pressed():
	if is_satisfied(awakeness):
		#play nono animation
		pass
	else:
		awakeness = min(awakeness + needGain, 100)


func _on_PlayButton_pressed():
	if is_satisfied(fun):
		#play nono animation
		pass
	else:
		fun = min(fun + needGain, 100)


func _on_ExtraButton_pressed():
	if is_satisfied(happiness):
		#play nono animation
		pass
	else:
		happiness = min(happiness + needGain, 100)


func _on_DialogManager_reduce_awakeness(amount):
	reduce_awakeness(amount)


func _on_DialogManager_reduce_fullness(amount):
	reduce_fullness(amount)


func _on_DialogManager_reduce_fun(amount):
	reduce_fun(amount)


func _on_DialogManager_reduce_happiness(amount):
	reduce_happiness(amount)


func _on_DialogManager_reduce_everything(amount):
	reduce_all_needs(amount)
