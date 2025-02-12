extends Node3D

@export var camera:Camera3D  
@export var card:PackedScene  
var speed: float = 10.0 

func _process(_delta):
	rotate_tocursor()
	if Input.is_action_just_pressed("ui_down"):
		launch_card()

func rotate_tocursor():
	var mous_pos = get_viewport().get_mouse_position()
	var rayori = camera.project_ray_origin(mous_pos)
	var raydir = camera.project_ray_normal(mous_pos)

	var tarz = global_transform.origin.z  
	if abs(raydir.z) < 0.001:
		return  
	var t = (tarz - rayori.z) / raydir.z
	if t < 0:
		return
	var tarpos = rayori + raydir * t
	var dir = (tarpos - global_transform.origin).normalized()
	var angle = atan2(dir.y, dir.x)
	rotation.z = angle

func launch_card():
	var card_inst = card.instantiate()
	get_tree().current_scene.add_child(card_inst)
	card_inst.global_position = $Marker3D2.global_position
	card_inst.rotation.z = rotation.z
	var mouspos = get_viewport().get_mouse_position()
	var rayori = camera.project_ray_origin(mouspos)
	var raydir = camera.project_ray_normal(mouspos)
	var tarz = global_transform.origin.z 
	if abs(raydir.z) < 0.001:
		return 
	var t = (tarz - rayori.z) / raydir.z
	if t < 0:
		return
	var target_position = rayori + raydir * t
	var direction = (target_position - global_transform.origin).normalized()
	card_inst.launch(direction, speed)
