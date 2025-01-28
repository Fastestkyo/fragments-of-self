extends Node3D

var playerindirt = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		playerindirt = true

func _process(delta: float) -> void:
	if playerindirt and Input.is_action_just_pressed("ui_down") and GameManager.inv['shovel'] > 0:
		GameManager.inv['shovel'] = 0
		self.queue_free()
		
