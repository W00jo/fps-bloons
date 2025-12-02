extends Node3D

@onready var crosshair: TextureRect = $Player/HUD2/Crosshair
@onready var hitmarker: TextureRect = $Player/HUD2/Hitmarker
@onready var score_background : Panel = $Player/HUD2/ScoreBackground

@export var score_indicator : Label

@export var score : int = 0

func _ready():
	crosshair.position.x = get_viewport().size.x / 2 - 32
	crosshair.position.y = get_viewport().size.y / 2 - 32
	hitmarker.position.x = get_viewport().size.x / 2 - 32
	hitmarker.position.y = get_viewport().size.y / 2 - 32
	
	score_background.position.x = get_viewport().size.x / 2 - 32
	score_background.position.y = 20 # A small margin from the top

func _score_update(bloon_points) -> void:
	score += bloon_points
	print(score)
	score_indicator.text = str("Przebito: ", score)
