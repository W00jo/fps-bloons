extends Node3D

const SPEED = 10.0

@onready var mesh = $ProjectileModel
@onready var ray = $RayCast3D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, SPEED) * delta
	
	if ray.is_colliding():
		var collider = ray.get_collider()
		print("Ahh! I'll get you next time, pesky monkey!")
		
		# Check if we hit a bloon
		if collider.is_in_group("bloons"):
			collider._hit()
		
		mesh.visible = false
		await get_tree().create_timer(0.1).timeout
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
