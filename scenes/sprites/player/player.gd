extends CharacterBody3D
@onready var anim: AnimatedSprite3D = $AnimatedSprite3D

@export var SPEED = 5
@export var max_jump:int = 2
const JUMP_VELOCITY = 4.5
var grav = 20
var ladder_position = Vector3.ZERO
var dir
var dashactive = true
var dashing = false
var candash = true
var dubleactive = true
var jump_count = 0


enum state {
	NORMAL, LADDER
}
var current_state = state.NORMAL

func _physics_process(delta: float) -> void:
	
	if dubleactive:
		max_jump = 2
	else:
		max_jump = 1
	if current_state == state.LADDER:
		grav = 0  
		velocity.y = 0  
		var direction_to_ladder = (ladder_position - global_transform.origin).x
		if direction_to_ladder > 0 and Input.is_action_pressed("ui_right"):
			velocity.y = lerpf(velocity.y, SPEED, delta * 8)
		elif direction_to_ladder < 0 and Input.is_action_pressed("ui_left"):
			velocity.y = lerpf(velocity.y, SPEED, delta * 8)
		else:
			velocity.y = lerpf(velocity.y, 0, delta * 8)
	else:
		if !is_on_floor():
			grav = 20
			velocity.y += -(grav * delta)
			anim.play('jump')
		else:
			if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
				anim.play('walk')
			else:
				anim.play('idle')
	
	if Input.is_action_just_pressed("dash") and candash:
		if dashactive:
			dashing = true
			candash = false
			$dash.start()
			$candash.start()

	if Input.is_action_just_pressed("ui_accept") and jump_count < max_jump:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		$jump.start()

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
	else:
		velocity.x = 0
	velocity.z = 0 
	physics_logic()
	move_and_slide()


func _on_timer_timeout() -> void:
	dashing = false

func _on_candash_timeout() -> void:
	candash = true

func _on_jump_timeout() -> void:
	jump_count = 0

func death():
	get_tree().reload_current_scene()

func physics_logic():
	for i in get_slide_collision_count():
		var col = get_slide_collision(i).get_collider()
		if col is RigidBody3D:
			col.apply_central_impulse(-get_slide_collision(i).get_normal() * 0.002)
