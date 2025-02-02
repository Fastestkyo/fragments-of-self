extends CharacterBody3D

@onready var anim: AnimatedSprite3D = $AnimatedSprite3D

@export var SPEED = 5
@export var max_jump: int = 1
var JUMP_VELOCITY = 4.5
var grav = 20
var ladder_position = Vector3.ZERO
var dir
var dashactive = true
var dashing = false
var candash = true
var dubleactive = false
var jump_count = 0
var gliding = false
var can_glide = false
var dashsped = 15


enum state {
	NORMAL, LADDER, SLAM
}
var current_state = state.NORMAL

func _physics_process(delta: float) -> void:
	match current_state:
		state.NORMAL:
			handle_normal_state(delta)
		state.LADDER:
			handle_ladder_state(delta)
		state.SLAM:
			handle_slam_state(delta)
	if Input.is_action_just_pressed("dash") and candash and dashactive:
		dashing = true
		candash = false
		print('dash')
		$dash.start()
		$candash.start()
	bodyparts()
	move_and_slide()

func handle_normal_state(delta: float):
	grav = 20
	velocity.y += -(grav * delta)

	if is_on_floor():
		jump_count = 0
		gliding = false
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			if GameManager.noshard in range(1, 10):
				if GameManager.noshard <= GameManager.memshard or GameManager.noshard == 0 and GameManager.memshard == 0:
					anim.play("walk" + str(GameManager.noshard))
				elif GameManager.noshard > GameManager.memshard:
					anim.play("nwalk")
		else:
			if GameManager.noshard in range(1, 10):
				if GameManager.noshard == GameManager.memshard:
					anim.play("idle" + str(GameManager.noshard))
				elif GameManager.noshard > GameManager.memshard:
					anim.play("nidle")

	else:
		if Input.is_action_just_pressed("glide") and can_glide:
			gliding = true
			grav = 5
		if gliding and can_glide:
			velocity.y += -(grav * delta)
		if GameManager.noshard in range(1, 10):
			anim.play('jump' + str(GameManager.noshard))

	# Jump Logic
	if Input.is_action_just_pressed("ui_accept"):
		if jump_count == 0:  # First jump is always allowed
			velocity.y = JUMP_VELOCITY
			jump_count += 1
			$jump.start()
		elif jump_count == 1 and dubleactive:  # Second jump only if dubleactive is true
			velocity.y = JUMP_VELOCITY
			jump_count += 1
			$jump.start()

	

	handle_movement(delta)

func handle_ladder_state(delta: float):
	grav = 0
	velocity.y = 0
	
	var direction_to_ladder = (ladder_position - global_transform.origin).x
	if direction_to_ladder > 0 and Input.is_action_pressed("ui_right"):
		velocity.y = lerpf(velocity.y, SPEED, delta * 18)
	elif direction_to_ladder < 0 and Input.is_action_pressed("ui_left"):
		velocity.y = lerpf(velocity.y, SPEED, delta * 18)
	else:
		velocity.y = lerpf(velocity.y, 0, delta * 18)

func handle_slam_state(delta: float):
	velocity.y = -30
	if is_on_floor():
		current_state = state.NORMAL

func handle_movement(delta: float):
	dir = Input.get_axis("ui_left", "ui_right")
	
	if dir < 0:
		anim.flip_h = false
	elif dir > 0:
		anim.flip_h = true

	if dir:
		if dashing:
			velocity.x = dir * dashsped
		else:
			velocity.x = dir *SPEED
	else:
		velocity.x = 0

	velocity.z = 0
	physics_logic()

func _on_timer_timeout() -> void:
	dashing = false

func _on_candash_timeout() -> void:
	candash = true

func _on_jump_timeout() -> void:
	jump_count = 0

func death():
	call_deferred("_reload_scene")

func _reload_scene():
	get_tree().reload_current_scene()

func physics_logic():
	for i in get_slide_collision_count():
		var col = get_slide_collision(i).get_collider()
		if col is RigidBody3D:
			col.apply_central_impulse(-get_slide_collision(i).get_normal() * 0.002)

func bodyparts():
	if GameManager.noshard == 0:
		SPEED = 2
		JUMP_VELOCITY = 1.5
		candash= false
	elif GameManager.noshard == 1 and GameManager.memshard == 1:
		SPEED = 3
		candash= false
		JUMP_VELOCITY = 3.5
	elif GameManager.noshard == 2 and GameManager.memshard == 2:
		SPEED = 5
		JUMP_VELOCITY = 4.7
		candash= false
	elif GameManager.noshard == 3 and GameManager.memshard == 3:
		SPEED = 5
		JUMP_VELOCITY = 4.7
		candash= true
		dashsped = 4
	elif GameManager.noshard == 4 and GameManager.memshard == 4:
		SPEED = 5
		JUMP_VELOCITY = 4.7
		candash= true
		dashsped = 7
	elif GameManager.noshard == 3 and GameManager.memshard == 3:
		SPEED = 5
		JUMP_VELOCITY = 4.7
		candash= true
		dashsped = 10
	elif GameManager.noshard > GameManager.memshard:
		SPEED = 5
		JUMP_VELOCITY = 6
