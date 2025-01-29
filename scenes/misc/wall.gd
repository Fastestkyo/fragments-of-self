extends StaticBody3D



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == 'ball':
		self.queue_free()
		body.queue_free()
