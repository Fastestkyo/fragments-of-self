extends Node3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		emit_signal('picked')
		GameManager.inv['shovel'] += 1
		print(GameManager.inv)
		queue_free()
