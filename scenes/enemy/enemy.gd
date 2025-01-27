extends CharacterBody3D
@onready var anim: AnimatedSprite3D = $AnimatedSprite3D
@export var move_speed: float = 1.0
@export var move_axis: Vector3 = Vector3(1, 0, 0) 
var player: Node3D = null
var is_chasing: bool = false
var grav = 25

func _physics_process(delta: float):
	chase()
	move_and_slide()
	if !is_on_floor():
		velocity.y += grav * delta


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "player":
		player = body
		is_chasing = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "player":
		is_chasing = false
		player = null

func chase():
	if is_chasing and player:
		var dir = (player.global_position - global_position).normalized()
		dir = dir.project(move_axis)
		velocity = dir * move_speed
		if dir:
			anim.play('walk')
			if dir > Vector3.ZERO:
				anim.flip_h = true
			elif dir < Vector3.ZERO:
				anim.flip_h = false
		
	else:
		velocity = Vector3.ZERO
		anim.play('idle')
