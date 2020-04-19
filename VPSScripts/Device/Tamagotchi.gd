extends Node2D

signal switch_to_sick
signal switch_to_pet
signal tamagotchi_died

var age: float = 0
var stage: int = 0
var minigame: bool = false

var fullness: float = 100
var awakeness: float = 100
var fun: float = 100
var happiness: float = 100

var needDecay: float = 0
export(int) var needDecayPerSecond: int = 1

export(float) var needGain = 10

onready var fullProgressBar = $Screen/HomeScreen/UIContainer/FullnessUI/TextureProgress
onready var awakeProgressBar = $Screen/HomeScreen/UIContainer/AwakenessUI/TextureProgress
onready var funProgressBar = $Screen/HomeScreen/UIContainer/FunUI/TextureProgress
onready var petHappyProgressBar = $Screen/HomeScreen/UIContainer/PetHappinessUI/TextureProgress
onready var sickHappyProgressBar = $Screen/HomeScreen/UIContainer/SickHappinessUI/TextureProgress

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("switch_to_pet")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not minigame:
		needDecay += delta * needDecayPerSecond
		if needDecay > 10:
			change_all_needs(-10)
			needDecay -= 10
		
		age += delta
		if stage < 2 and age > 100:
			age_up()
			age = 0

func change_fullness(amount):
	if amount > 0 and is_satisfied(fullness):
		#play nono animation
		pass
	else:
		fullness = min(fullness + amount, 100)
		fullProgressBar.value = fullness
		die_if_dead()

func change_awakeness(amount):
	if amount > 0 and is_satisfied(awakeness):
		#play nono animation
		pass
	else:
		awakeness = min(awakeness + amount, 100)
		awakeProgressBar.value = awakeness
		die_if_dead()

func change_fun(amount):
	if amount > 0 and is_satisfied(fun):
		#play nono animation
		pass
	else:
		fun = min(fun + amount, 100)
		funProgressBar.value = fun
		die_if_dead()

func change_happiness(amount):
	if amount > 0 and is_satisfied(happiness):
		#play nono animation
		pass
	else:
		happiness = min(happiness + amount, 100)
		petHappyProgressBar.value = happiness
		sickHappyProgressBar.value = happiness
		die_if_dead()

func change_all_needs(amount):
	change_fullness(amount)
	change_awakeness(amount)
	change_fun(amount)
	change_happiness(amount)

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

func switch_to_minigame():
	$Screen/HomeScreen.visible = false
	$Screen/MinigameScreen.visible = true
	var enemies = get_tree().get_nodes_in_group("minigame_objects")
	get_tree().call_group("minigame_objects", "unpause")
	minigame = true

func switch_to_home():
	$Screen/HomeScreen.visible = true
	$Screen/MinigameScreen.visible = false
	get_tree().call_group("minigame_objects", "pause")
	minigame = false

func _on_FoodButton_pressed():
	if minigame:
		$Screen/MinigameScreen.moveLeft()
	else:
		change_fullness(needGain)

func _on_SleepButton_pressed():
	if minigame:
		$Screen/MinigameScreen.shoot()
	else:
		change_awakeness(needGain)


func _on_PlayButton_pressed():
	if minigame:
		$Screen/MinigameScreen.moveRight()
	else:
		change_fun(needGain)
		switch_to_minigame()


func _on_ExtraButton_pressed():
	if minigame:
		switch_to_home()
	else:
		change_happiness(needGain)


func _on_DialogManager_reduce_awakeness(amount):
	change_awakeness(-amount)


func _on_DialogManager_reduce_fullness(amount):
	change_fullness(-amount)


func _on_DialogManager_reduce_fun(amount):
	change_fun(-amount)


func _on_DialogManager_reduce_happiness(amount):
	change_happiness(-amount)


func _on_DialogManager_reduce_everything(amount):
	change_all_needs(-amount)
