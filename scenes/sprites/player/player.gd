extends CharacterBody3D
@onready var anim: AnimatedSprite3D = $AnimatedSprite3D

@export var SPEED = 1
const JUMP_VELOCITY = 4.5
const grav = 25
var dir
var dashactive = true
var dashing = false
var candash = true
var dubleactive = false



func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += -(grav * delta)
		anim.play('jump')
		
	else:
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			anim.play('walk')
		else:
			anim.play('idle')
			
	if Input.is_action_just_pressed("dash") and candash:
		if dashactive == true:
			
			dashing = true
			candash = false
			$dash.start()
			$candash.start()

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	dir = Input.get_axis("ui_left", "ui_right")
	if dir < 0:
		anim.flip_h = false
	
	elif dir > 0:
		anim.flip_h = true
	
	if dir:
		if dashing:
			velocity.x = dir * 7
		else:
			velocity.x = dir * SPEED
			$Camera3D.add_trauma(0.5)
	else:
		velocity.x = 0
	velocity.z = 0 

	move_and_slide()


func _integrate_forces(state):
	state.transform.origin.z = 0 

func _on_timer_timeout() -> void:
	dashing = false



func _on_candash_timeout() -> void:
	candash = true
