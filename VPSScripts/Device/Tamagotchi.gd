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
signal hatch

enum STAGE{
	egg,
	baby,
	adult,
	old}

enum STATE{
	off,
	home,
	minigame,
	gameOver}

onready var stageSpriteMap = {
	STAGE.egg: $Screen/HomeScreen/NormalSprites/EggSprite,
	STAGE.baby: $Screen/HomeScreen/NormalSprites/BabySprite,
	STAGE.adult: $Screen/HomeScreen/NormalSprites/AdultSprite,
	STAGE.old: $Screen/HomeScreen/NormalSprites/OldSprite}

onready var stageNameMap = {
	"egg" : STAGE.egg,
	"young" : STAGE.baby,
	"adult" : STAGE.adult,
	"old" : STAGE.old}

var age: float = 0
var stage: int = STAGE.egg
var state: int = STATE.home
var sleeping: bool = false

var fullness: float = 100
var awakeness: float = 100
var fun: float = 100
var happiness: float = 100

var needDecay: float = 0
export(int) var needDecayPerSecond: int = 1
export(int) var agingPerSecond: int = 5

export(float) var needGain = 10

export(int) var minimumNeedAfterDialog: int = 15

var minigameScreenScene = preload("res://VPSScenes/Minigame/TamagotchiMinigameScreen.tscn")
onready var minigameScreen = $Screen/MinigameScreen

onready var fullProgressBar = $Screen/HomeScreen/UIContainer/FullnessUI/TextureProgress
onready var awakeProgressBar = $Screen/HomeScreen/UIContainer/AwakenessUI/TextureProgress
onready var funProgressBar = $Screen/HomeScreen/UIContainer/FunUI/TextureProgress
onready var petHappyProgressBar = $Screen/HomeScreen/UIContainer/PetHappinessUI/TextureProgress
onready var sickHappyProgressBar = $Screen/HomeScreen/UIContainer/SickHappinessUI/TextureProgress

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("switch_to_pet")
	switch_to_home()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if stage != STAGE.egg and state != STATE.off:
		needDecay += delta * needDecayPerSecond
		if needDecay > 10:
			needDecay -= 10
			if state == STATE.minigame:
				change_fun(5)
			elif not sleeping:
				change_all_needs(-10)
			else:
				change_fullness(-5)
				change_fun(-5)
				change_happiness(-5)
				change_awakeness(20)
	
	if state == STATE.home:
		age += delta * agingPerSecond
		if stage < STAGE.old and age > 100:
			change_stage_to(stage + 1)
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
	

func change_fullness(amount, minValue = 0):
	if amount > 0 and is_satisfied(fullness):
		emit_signal("refuse")
	else:
		if amount > 0:
			emit_signal("eat")
		fullness = clamp(fullness + amount, min(minValue, fullness), 100)
		fullProgressBar.value = fullness
		react_to_low_needs()

func change_awakeness(amount, minValue = 0):
	if amount > 0 and is_satisfied(awakeness):
		toggle_sleep()
	else:
		awakeness = clamp(awakeness + amount, min(minValue, awakeness), 100)
		awakeProgressBar.value = awakeness
		react_to_low_needs()

func change_fun(amount, minValue = 0):
	if amount > 0 and is_satisfied(fun):
		emit_signal("refuse")
	else:
		fun = clamp(fun + amount, min(minValue, fun), 100)
		funProgressBar.value = fun
		react_to_low_needs()

func change_happiness(amount, minValue = 0):
	if amount > 0 and is_satisfied(happiness):
		emit_signal("refuse")
	else:
		if amount > 0:
			emit_signal("happy")
		happiness = clamp(happiness + amount, min(minValue, happiness), 100)
		petHappyProgressBar.value = happiness
		sickHappyProgressBar.value = happiness
		react_to_low_needs()

func change_all_needs(amount, minValue = 0):
	change_fullness(amount, minValue)
	change_awakeness(amount, minValue)
	change_fun(amount, minValue)
	change_happiness(amount, minValue)

func die_if_dead():
	if fullness <= 0 or awakeness <= 0 or fun <= 0 or happiness <= 0:
		die()

func be_sad_if_not_cared_for():
	if fullness <= 15 or awakeness <= 15 or fun <= 15 or happiness <= 15:
		if not is_animating() and not sleeping:
			emit_signal("sad")
	else:
		emit_signal("not_sad")

func react_to_low_needs():
	die_if_dead()
	be_sad_if_not_cared_for()

func die():
	emit_signal("tamagotchi_died")

func change_stage_to(newStage):
	if stage == STAGE.egg:
		emit_signal("hatch")
	hide_sprite(stage)
	stage = newStage
	show_sprite(stage)
	if stage == STAGE.old:
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
	minigameScreen.visible = true
	$Screen/GameOverScreen.visible = false
	get_tree().call_group("minigame_objects", "unpause")
	state = STATE.minigame

func switch_to_gameOver():
	$Screen/HomeScreen.visible = false
	minigameScreen.visible = false
	$Screen/GameOverScreen.visible = true
	get_tree().call_group("minigame_objects", "pause")
	state = STATE.gameOver

func switch_to_off():
	$Screen/HomeScreen.visible = false
	minigameScreen.visible = false
	$Screen/GameOverScreen.visible = false
	get_tree().call_group("minigame_objects", "pause")
	state = STATE.off

func switch_to_home():
	$Screen/HomeScreen.visible = true
	minigameScreen.visible = false
	$Screen/GameOverScreen.visible = false
	get_tree().call_group("minigame_objects", "pause")
	state = STATE.home

func restart_minigame():
	minigameScreen.queue_free()
	minigameScreen = minigameScreenScene.instance()
	$Screen.call_deferred("add_child", minigameScreen)
	minigameScreen.connect("game_over", $Screen, "_on_MinigameScreen_game_over")
	

func _on_FoodButton_pressed():
	if state == STATE.gameOver:
		switch_to_home()
	elif state == STATE.minigame:
		minigameScreen.moveLeft()
	elif not is_animating() and state != STATE.off:
		if sleeping:
			toggle_sleep()
		change_fullness(needGain)

func _on_SleepButton_pressed():
	if state == STATE.gameOver:
		switch_to_home()
	elif state == STATE.minigame:
		minigameScreen.shoot()
	elif not is_animating() and state != STATE.off:
		toggle_sleep()


func _on_PlayButton_pressed():
	if state == STATE.gameOver:
		switch_to_home()
	elif state == STATE.minigame:
		minigameScreen.moveRight()
	elif not is_animating() and state != STATE.off:
		if sleeping:
			toggle_sleep()
		if stage != STAGE.egg:
			switch_to_minigame()


func _on_ExtraButton_pressed():
	if state == STATE.minigame or state == STATE.gameOver:
		switch_to_home()
	elif not is_animating() and state != STATE.off:
		if sleeping:
			toggle_sleep()
		change_happiness(needGain)


func _on_DialogManager_reduce_awakeness(amount):
	change_awakeness(-amount, minimumNeedAfterDialog)


func _on_DialogManager_reduce_fullness(amount):
	change_fullness(-amount, minimumNeedAfterDialog)


func _on_DialogManager_reduce_fun(amount):
	change_fun(-amount, minimumNeedAfterDialog)


func _on_DialogManager_reduce_happiness(amount):
	change_happiness(-amount, minimumNeedAfterDialog)


func _on_DialogManager_reduce_everything(amount):
	change_all_needs(-amount, minimumNeedAfterDialog)


func _on_TamagotchiTextBox_start_talking():
	emit_signal("start_talking")


func _on_TamagotchiTextBox_end_talking():
	emit_signal("end_talking")


func _on_DialogManager_turn_tamagotchi_off():
	switch_to_off()


func _on_DialogManager_turn_tamagotchi_on():
	switch_to_home()


func _on_Screen_game_over():
	restart_minigame()
	switch_to_gameOver()


func _on_DialogManager_change_squid_stage(newStageName):
	change_stage_to(stageNameMap[newStageName])
