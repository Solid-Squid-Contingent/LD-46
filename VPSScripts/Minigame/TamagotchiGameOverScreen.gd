extends TextureRect

onready var scoreLabel = $ScoreLabel
onready var highScoreLabel = $HighScoreLabel

func _ready():
	pass

func set_score(score: int):
	scoreLabel.set_text(String(score))

func set_high_score(highScore: int):
	highScoreLabel.set_text(String(highScore))
