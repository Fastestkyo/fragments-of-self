extends Camera3D

@export var decay: float = 0.8
@export var max_offset: Vector3 = Vector3(1, 1, 0)
@export var max_roll: float = 0.1
@export var follow_node: Node3D

var trauma: float = 0.0
var trauma_power: int = 2
var original_offset: Vector3 = Vector3.ZERO

func _ready() -> void:
	original_offset = global_transform.origin
	randomize()

func _process(delta: float) -> void:
	if follow_node:
		global_transform.origin = follow_node.global_transform.origin + original_offset
	if trauma > 0:
		trauma = max(trauma - decay * delta, 0)
		apply_shake()

func add_trauma(amount: float) -> void:
	trauma = min(trauma + amount, 1.0)

func apply_shake() -> void:
	var amount = pow(trauma, trauma_power)
	var random_offset = Vector3(
		randf_range(-max_offset.x, max_offset.x) * amount,
		randf_range(-max_offset.y, max_offset.y) * amount,
		randf_range(-max_offset.z, max_offset.z) * amount
	)
	var random_roll = max_roll * amount * randf_range(-1, 1)
	var shaken_transform = global_transform
	shaken_transform.origin += random_offset
	shaken_transform.basis = shaken_transform.basis.rotated(Vector3(0, 0, 1), random_roll)
	global_transform = shaken_transform
