extends Area3D

# Zmienne dt. balansu
## Punkty jakie otrzymujemy za "przebicie" balona
@export var pop_points := 1
## Punkty życia balona
@export var bloon_hitpoints := 1
# Zmienne dt. wizualiów
@export var bloon_inflation : float = 0.2

@onready var pop_sound = $PopSound
@onready var mesh = $BloonModel

var is_being_poped := false

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	if not is_being_poped:
		# Powolna rotacja balona
		rotate_y(0.01)

## Obsługuje trafienie balona = odejmuje HP lub powiększa balon
func _hit():
	if is_being_poped:
		return
	
	bloon_hitpoints -= 1
	
	if bloon_hitpoints <= 0:
		# Balon przebity = odtwarza dźwięk i aktualizuje wynik
		is_being_poped = true
		pop_sound.play()
		var main = get_tree().root.get_node("Main")
		if main:
			main._score_update(pop_points)
		
		mesh.visible = false
		$BloonCollisionShape.disabled = true
		
		await pop_sound.finished
		queue_free()
	else:
		# Balon powiększa się po trafieniu, ale tego nie widać xd
		scale += Vector3.ONE * bloon_inflation
