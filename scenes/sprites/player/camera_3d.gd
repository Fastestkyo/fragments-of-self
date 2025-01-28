extends Camera3D

# Variables to control shake
@export var shake_intensity: float = 1.0
@export var shake_decay: float = 10.0
@export var shake_duration: float = 0.5

# Internal variables
var _shake_time: float = 0.0
var _original_position: Vector3 = Vector3.ZERO
var _is_shaking: bool = false
var _player: Node3D = null  # Reference to the player

# Called to start the shake
func shake(intensity: float, duration: float) -> void:
	_shake_time = duration
	shake_intensity = intensity
	_original_position = position  # Store the original camera position
	_is_shaking = true

# Set the player to follow
func set_player(player: Node3D) -> void:
	_player = player

# Called every frame
func _process(delta: float) -> void:
	if _player == null:
		return
	
	if _is_shaking:
		if _shake_time > 0:
			_shake_time -= delta
			var offset_position = Vector3(
				randf_range(-1, 1) * shake_intensity,
				randf_range(-1, 1) * shake_intensity,
				0
			)
			
			# Apply shake only to the local position of the camera
			position = _original_position + offset_position
			
			# Reduce intensity over time
			shake_intensity = max(shake_intensity - shake_decay * delta, 0)
		else:
			# Reset camera and stop shaking
			position = _original_position
			_is_shaking = false
	else:
		# Keep the camera centered on the player (without shaking)
		position = _player.position + Vector3(0, 2, -5)  # Adjust this offset as needed
