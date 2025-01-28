extends CharacterBody3D
@onready var anim: AnimatedSprite3D = $AnimatedSprite3D

const SPEED = 1
const JUMP_VELOCITY = 4.5
const grav = 25
var dir


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += -(grav * delta)
		anim.play('jump')
	else:
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			anim.play('walk')
		else:
			anim.play('idle')

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("ui_left"):
		dir = -1
		anim.flip_h = false
	elif Input.is_action_pressed("ui_right"):
		dir = 1
		anim.flip_h = true
	else:
		dir = 0

	velocity.x = dir * SPEED
	velocity.z = 0 

	
	move_and_slide()


func _integrate_forces(state):
	state.transform.origin.z = 0 # Lock position on Z-axis for collisions
