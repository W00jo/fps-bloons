extends Node3D

@onready var crosshair: TextureRect = $Player/HUD/Crosshair
@onready var hitmarker: TextureRect = $Player/HUD/Hitmarker
@onready var score_background : Panel = $Player/HUD/ScoreBackground
@onready var playable_region: CSGBox3D = $PlayableRegion
@onready var enemies_node: Node3D = $Enemies
@onready var main_theme: AudioStreamPlayer = $MainTheme

@export var score_indicator : Label
@export var score : int = 0
@export var respawn_delay : float = 1.0
@export var max_bloons : int = 5
@export var fade_in_duration : float = 2.0
@export var hitmarker_duration : float = 0.2

var bloon_scene = preload("res://src/enemies/bloon.tscn")
var current_bloon_count : int = 0

func _ready():
	# Ustawia celownik na środku ekranu
	crosshair.position.x = get_viewport().size.x / 2 - 32
	crosshair.position.y = get_viewport().size.y / 2 - 32
	hitmarker.position.x = get_viewport().size.x / 2 - 32
	hitmarker.position.y = get_viewport().size.y / 2 - 32
	
	score_background.position.x = get_viewport().size.x / 2 - 32
	score_background.position.y = 20
	
	current_bloon_count = enemies_node.get_child_count()
	
	# Inicjalizuje wyświetlanie wyniku
	score_indicator.text = tr("SCORE_POPPED") + " " + str(score)
	
	_start_music_with_fade()
	
## Muzyka zacyzna grać przy "wejściu" na scenę
func _start_music_with_fade() -> void:
	# Zaczyna z wytłumieniem
	main_theme.volume_db = -80.0
	main_theme.play()
	var target_volume = -2.0
	var tween = create_tween()
	tween.tween_property(main_theme, "volume_db", target_volume, fade_in_duration)
	
	# Loop
	main_theme.finished.connect(_on_music_finished)
	
func _on_music_finished() -> void:
	main_theme.play()
	
## Aktualizuje wynik po przebiciu balona i spawnuje nowego
func _score_update(bloon_points) -> void:
	score += bloon_points
	print(score)
	score_indicator.text = tr("SCORE_POPPED") + " " + str(score)
	
	_show_hitmarker()
	
	# Zmniejsza licznik i spawnuje nowego balona po opóźnieniu
	current_bloon_count -= 1
	await get_tree().create_timer(respawn_delay).timeout
	_spawn_bloons()
	
## Hitmarker after popping bloon
func _show_hitmarker() -> void:
	hitmarker.visible = true
	hitmarker.modulate.a = 1.0
	
	var tween = create_tween()
	tween.tween_property(hitmarker, "modulate:a", 0.0, hitmarker_duration)
	await tween.finished
	hitmarker.visible = false
	
## Spawnuje nowego balona w losowej pozycji w obszarze gry
func _spawn_bloons():
	if current_bloon_count >= max_bloons:
		return
	
	var bloon = bloon_scene.instantiate()
	var random_pos = get_random_position_in_region()
	bloon.position = random_pos
	
	enemies_node.add_child(bloon)
	current_bloon_count += 1
	
## Zwraca losową pozycję w granicach obszaru gry
func get_random_position_in_region() -> Vector3:
	var ground_size = Vector3(15, 0, 15)
	var ground_position = playable_region.position
	
	var random_x = randf_range(-ground_size.x / 2, ground_size.x / 2)
	var random_z = randf_range(-ground_size.z / 2, ground_size.z / 2)
	var y_height = 1.5
	
	return Vector3(random_x, y_height, random_z) + ground_position
	
func fade_out_music(duration: float = 1.5) -> void:
	var tween = create_tween()
	tween.tween_property(main_theme, "volume_db", -80.0, duration)
	await tween.finished
	main_theme.stop()
