extends CharacterBody3D

enum State { NORMAL, CLING }
var current_state = State.NORMAL

@export var speed: float = 5.0
@export var jump_force: float = 6.0
@export var wall_jump_force: Vector3 = Vector3(6, 8, 0)
@export var gravity: float = 15.0

var direction: Vector3 = Vector3.ZERO
var jump_count: int = 0

@onready var anim = $AnimationPlayer

func _physics_process(delta):
	# Apply gravity unless clinging
	if not is_on_floor() and current_state != State.CLING:
		velocity.y -= gravity * delta

	match current_state:
		State.NORMAL:
			handle_normal_state(delta)
		State.CLING:
			handle_cling_state(delta)

	move_and_slide()

func handle_normal_state(delta: float):
	var input_dir = Input.get_axis("ui_left", "ui_right")
	direction = Vector3(input_dir, 0, 0)

	if direction.x != 0:
		velocity.x = direction.x * speed
		anim.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		anim.play("idle")

	# Jump logic
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force
		jump_count = 1
		anim.play("jump")

	# Wall detection using test_move() instead of RayCast
	if not is_on_floor() and check_wall_collision():
		current_state = State.CLING

func handle_cling_state(delta: float):
	velocity.y = 0  # Stop falling
	anim.play("cling")  # Play cling animation

	# Wall jump
	if Input.is_action_just_pressed("ui_accept"):
		var wall_normal = get_wall_normal()
		velocity.y = wall_jump_force.y
		velocity.x = wall_normal.x * wall_jump_force.x
		current_state = State.NORMAL

	# If no longer touching a wall, switch back to normal state
	if not check_wall_collision():
		current_state = State.NORMAL

func check_wall_collision() -> bool:
	# Test movement slightly forward to check if there's a wall
	var test_position = global_transform.origin + Vector3(direction.x * 0.1, 0, 0)
	return not test_move(Transform3D(), test_position - global_transform.origin)

func get_wall_norma() -> Vector3:
	# Get the direction of the wall (opposite of player movement)
	return Vector3(-direction.x, 0, 0)
