extends Node3D
@export var gate : Node3D
var isplr : bool = false
var isused : bool = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		isplr = true

func _process(_delta: float) -> void:
	if isplr and Input.is_action_just_pressed("ui_accept") and isused == false:
		gate.open()
		isused = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == 'player':
		isplr = false
