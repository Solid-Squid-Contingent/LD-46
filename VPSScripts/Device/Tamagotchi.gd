extends Node2D

signal switch_to_sick
signal switch_to_pet
signal tamagotchi_died

signal eat
signal start_sleeping
signal end_sleeping
signal happy
signal refuse
signal sad
signal not_sad
signal start_talking
signal end_talking

enum STAGE{
	egg,
	baby,
	adult,
	old}

onready var stageSpriteMap = {
	STAGE.egg: $Screen/HomeScreen/EggSprite,
	STAGE.baby: $Screen/HomeScreen/BabySprite,
	STAGE.adult: $Screen/HomeScreen/AdultSprite,
	STAGE.old: $Screen/HomeScreen/OldSprite}

var age: float = 0
var stage: int = STAGE.egg
var minigame: bool = false
var sleeping: bool = false

var fullness: float = 100
var awakeness: float = 100
var fun: float = 100
var happiness: float = 100

var needDecay: float = 0
export(int) var needDecayPerSecond: int = 1
export(int) var agingPerSecond: int = 5

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
	if stage != STAGE.egg:
		needDecay += delta * needDecayPerSecond
		if needDecay > 10:
			needDecay -= 10
			if minigame:
				change_fun(5)
			elif not sleeping:
				change_all_needs(-10)
			else:
				change_fullness(-5)
				change_fun(-5)
				change_happiness(-5)
				change_awakeness(20)
	
	if not minigame:
		age += delta * agingPerSecond
		if stage < STAGE.old and age > 100:
			age_up()
			age = 0

func is_animating() -> bool:
	return $Screen/HomeScreen.is_animating()

func toggle_sleep():
	if is_satisfied(awakeness) and not sleeping:
		emit_signal("refuse")
	else:
		sleeping = not sleeping
		if sleeping:
			emit_signal("start_sleeping")
		else:
			emit_signal("end_sleeping")
	

func change_fullness(amount):
	if amount > 0 and is_satisfied(fullness):
		emit_signal("refuse")
	else:
		if amount > 0:
			emit_signal("eat")
		fullness = min(fullness + amount, 100)
		fullProgressBar.value = fullness
		react_to_low_needs()

func change_awakeness(amount):
	if amount > 0 and is_satisfied(awakeness):
		toggle_sleep()
	else:
		awakeness = min(awakeness + amount, 100)
		awakeProgressBar.value = awakeness
		react_to_low_needs()

func change_fun(amount):
	if amount > 0 and is_satisfied(fun):
		emit_signal("refuse")
	else:
		fun = min(fun + amount, 100)
		funProgressBar.value = fun
		react_to_low_needs()

func change_happiness(amount):
	if amount > 0 and is_satisfied(happiness):
		emit_signal("refuse")
	else:
		if amount > 0:
			emit_signal("happy")
		happiness = min(happiness + amount, 100)
		petHappyProgressBar.value = happiness
		sickHappyProgressBar.value = happiness
		react_to_low_needs()

func change_all_needs(amount):
	change_fullness(amount)
	change_awakeness(amount)
	change_fun(amount)
	change_happiness(amount)

func die_if_dead():
	if fullness <= 0 or awakeness <= 0 or fun <= 0 or happiness <= 0:
		die()

func be_sad_if_not_cared_for():
	if fullness <= 15 or awakeness <= 15 or fun <= 15 or happiness <= 15:
		emit_signal("sad")
	else:
		emit_signal("not_sad")

func react_to_low_needs():
	die_if_dead()
	be_sad_if_not_cared_for()

func die():
	emit_signal("tamagotchi_died")

func age_up():
	hide_sprite(stage)
	stage += 1
	show_sprite(stage)
	if (stage == STAGE.old):
		emit_signal("switch_to_sick")
	
func is_satisfied(need) -> bool:
	if need >= 100:
		return true
	return false

func hide_sprite(oldStage):
	stageSpriteMap[oldStage].visible = false
	stageSpriteMap[oldStage].playing = false

func show_sprite(newStage):
	stageSpriteMap[newStage].playing = true
	stageSpriteMap[newStage].visible = true
	

func switch_to_minigame():
	$Screen/HomeScreen.visible = false
	$Screen/MinigameScreen.visible = true
	get_tree().call_group("minigame_objects", "unpause")
	minigame = true

func switch_to_home():
	$Screen/HomeScreen.visible = true
	$Screen/MinigameScreen.visible = false
	get_tree().call_group("minigame_objects", "pause")
	minigame = false

func _on_FoodButton_pressed():
	if not is_animating():
		if sleeping:
			toggle_sleep()
		if minigame:
			$Screen/MinigameScreen.moveLeft()
		else:
			change_fullness(needGain)

func _on_SleepButton_pressed():
	if not is_animating():
		if minigame:
			$Screen/MinigameScreen.shoot()
		else:
			toggle_sleep()


func _on_PlayButton_pressed():
	if not is_animating():
		if sleeping:
			toggle_sleep()
		if stage != STAGE.egg:
			if minigame:
				$Screen/MinigameScreen.moveRight()
			else:
				change_fun(needGain)
				switch_to_minigame()


func _on_ExtraButton_pressed():
	if not is_animating():
		if sleeping:
			toggle_sleep()
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


func _on_TamagotchiTextBox_start_talking():
	emit_signal("start_talking")


func _on_TamagotchiTextBox_end_talking():
	emit_signal("end_talking")
