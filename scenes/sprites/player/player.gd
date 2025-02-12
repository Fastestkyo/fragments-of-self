extends CharacterBody3D

@onready var anim: AnimatedSprite3D = $AnimatedSprite3D
@onready var card: Node3D = $card
@export var SPEED = 5
@export var ACCELERATION = 25
@export var max_jump: int = 2
var JUMP_VELOCITY = 5.5
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
var canswitchdim :bool = true
var fric = 5  

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
			
	if Input.is_action_just_pressed("1"):
		GameManager.currentcard = 0
	if Input.is_action_just_pressed("2"):
		GameManager.currentcard = 1
	if Input.is_action_just_pressed("dash") and candash and dashactive:
		dashing = true
		candash = false
		print('dash')
		$dash.start()
		$candash.start()
	
	if !is_on_floor() and Input.is_action_just_pressed("ui_down"):
		current_state = state.SLAM
	
	if Input.is_action_just_pressed("t"):
		if canswitchdim:
			change_dim()
			print(GameManager.currentdim)
	
	bodyparts()
	move_and_slide()


func handle_normal_state(delta: float):
	if GameManager.currentdim == 1:
		grav = 20
		fric = 20  
		velocity.y += -(grav * delta)
	elif GameManager.currentdim == 0:  
		grav = randi_range(10, 30)
		fric = 5  
		velocity.y += -(grav * delta) * 0.5 
	
	if is_on_floor():
		jump_count = 0
		gliding = false
	
	if Input.is_action_just_pressed("ui_accept"):
		if jump_count == 0:
			velocity.y = JUMP_VELOCITY
			jump_count += 1
			$jump.start()
		elif jump_count == 1 and dubleactive:
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

func handle_slam_state(_delta: float):
	if is_on_floor():
		var slam_force = -velocity.y * 1.5 
		velocity.y = slam_force
		current_state = state.NORMAL

	else:
		velocity.y = -30 

func handle_movement(delta: float):
	dir = Input.get_axis("ui_left", "ui_right")
	
	if dir < 0:
		anim.flip_h = false
	elif dir > 0:
		anim.flip_h = true
	
	if dir:
		var target_speed = dashsped if dashing else SPEED
		velocity.x = move_toward(velocity.x, dir * target_speed, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, fric * delta)
	
	velocity.z = 0
	physics_logic()

func _on_timer_timeout() -> void:
	dashing = false

func _on_candash_timeout() -> void:
	candash = true

func _on_jump_timeout() -> void:
	jump_count = 0

func physics_logic():
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		if col.get_collider() is RigidBody3D:
			col.get_collider().apply_central_impulse(-col.get_normal() * 1)

func change_dim():
	if GameManager.currentdim == 1:
		GameManager.currentdim = 0
		print("dreaasdifyioagfioagsiudm")
	elif GameManager.currentdim == 0:
		GameManager.currentdim = 1
		print("realitsrjhapisyf9aysfy")
	
	print(GameManager.currentdim)

func death():
	call_deferred("_death")
	
func _death():
	get_tree().reload_current_scene()

func bodyparts():
	#if GameManager.noshard == 0:
		#SPEED = 2
		#JUMP_VELOCITY = 1.5
		#candash= false
	#elif GameManager.noshard == 1 and GameManager.memshard == 1:
		#SPEED = 3
		#candash= false
		#JUMP_VELOCITY = 3.5
	#elif GameManager.noshard == 2 and GameManager.memshard == 2:
		#SPEED = 5
		#JUMP_VELOCITY = 4.7
		#candash= false
	#elif GameManager.noshard == 3 and GameManager.memshard == 3:
		#SPEED = 5
		#JUMP_VELOCITY = 4.7
		#candash= true
		#dashsped = 4
	#elif GameManager.noshard == 4 and GameManager.memshard == 4:
		#SPEED = 5
		#JUMP_VELOCITY = 4.7
		#candash= true
		#dashsped = 7
	#elif GameManager.noshard == 5 and GameManager.memshard == 5:
		#SPEED = 5
		#JUMP_VELOCITY = 4.7
		#candash= true
		#dashsped = 10
	#elif GameManager.noshard > GameManager.memshard:
		#SPEED = 5
		#JUMP_VELOCITY = 6
		pass
