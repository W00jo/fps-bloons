extends CharacterBody3D

@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export var MOUSE_SENSITIVITY = 0.003

var projectile = load("res://src/weapons/projectile.tscn")
var instance

@onready var camera = $PlayerHead/PlayerCamera
@onready var dart_anim = $PlayerHead/Dart/ThrowAnimation
@onready var dart_tip = $PlayerHead/Dart/RayCast3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	# Throwing
	if Input.is_action_pressed("throw"):
		if !dart_anim.is_playing():
			dart_anim.play("throw")
			instance = projectile.instantiate()
			instance.position = dart_tip.global_position
			instance.transform.basis = dart_tip.global_transform.basis
			get_parent().add_child(instance)
	
	move_and_slide()
