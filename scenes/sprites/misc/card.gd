extends Node3D

@export var rotation_smoothing: float = 5.0

func _process(delta):
	var camera = get_viewport().get_camera_3d()
	if camera == null:
		return

	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = camera.project_ray_normal(mouse_pos)
	
	var plane_z = global_transform.origin.z
	if abs(ray_direction.z) < 0.001:
		return
	var t = (plane_z - ray_origin.z) / ray_direction.z
	if t < 0:
		return
	var intersection = ray_origin + ray_direction * t

	# Compute the difference in the XY plane.
	var diff = intersection - global_transform.origin
	# Calculate the target angle (in radians) from the positive X axis.
	var target_angle = atan2(diff.y, diff.x)
	# Smoothly interpolate between the current angle and the target angle.
	rotation.z = lerp_angle(rotation.z, target_angle, rotation_smoothing * delta)
