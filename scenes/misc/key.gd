extends Node3D
@export var door : StaticBody3D



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		door.canopen = true
		print('asdasdasd')
		queue_free()
