extends StaticBody3D
@export var gate : StaticBody3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == 'player' or 'ball':
		gate.open()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == 'player' or 'ball':
		gate.close()
