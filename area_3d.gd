extends Area3D




func _on_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		body.current_state = body.state.LADDER
		body.ladder_position = global_position



func _on_body_exited(body: Node3D) -> void:
	if body.name == 'player':
		body.current_state = body.state.NORMAL
		body.ladder_position = Vector3.ZERO
	
