extends Node3D
var canopen = false
var isplr = false

func _physics_process(delta: float) -> void:
	open()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		isplr = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == 'player':
		isplr = false

func open():
	if isplr and Input.is_action_just_pressed('ui_down'):
		print('asdasd')
		queue_free()
