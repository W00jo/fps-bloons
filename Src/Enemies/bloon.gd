extends Area3D

# Zmienne dt. balansy
## Punkty jakie otrzymujemy za "przebicie" balona
@export var pop_points : int = 1
## Punkty życia balona
@export var bloon_hitpoints : int = 2

# Zmienne dt. wizualiów
@export var bloon_inflation : float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(0.01)

func _on_input_event(camera: Node, event: InputEvent,
event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		print("Pesky monkey! I'll get you next time!")
		scale += Vector3.ONE * bloon_inflation
		bloon_hitpoints -= 1
		
		if bloon_hitpoints == 0:
			get_node("/root/Main")._score_update(pop_points)
			queue_free()
