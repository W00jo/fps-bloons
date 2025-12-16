extends Control

@onready var menu_theme = $MenuTheme
@onready var start_button = $VBoxContainer/Start
@onready var easter_egg_button = $VBoxContainer/EasterEgg
@onready var exit_button = $VBoxContainer/Exit
@onready var pop_sound = $PopSound

func _ready() -> void:
	# Odtwarza muzykę menu
	menu_theme.play()

func _on_start_pressed() -> void:
	pop_sound.play()
	get_tree().change_scene_to_file("res://src/levels/main.tscn")

func _on_easter_egg_pressed() -> void:
	pop_sound.play()
	print("Easter egg")

## Przełącza język między angielskim a polskim
func _on_language_pressed() -> void:
	pop_sound.play()
	var current_locale = TranslationServer.get_locale()
	if current_locale == "en":
		TranslationServer.set_locale("pl")
	else:
		TranslationServer.set_locale("en")

func _on_exit_pressed() -> void:
	pop_sound.play()
	get_tree().quit()
