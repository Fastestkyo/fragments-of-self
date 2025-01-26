extends CharacterBody3D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var spr: Sprite3D = $Sprite3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var vely

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var move_dir = 0
	if Input.is_action_pressed("ui_left"):
		move_dir = -1
		spr.flip_h = false
		anim.current_animation = 'walk'
	elif Input.is_action_pressed("ui_right"):
		move_dir = 1
		spr.flip_h = true
		anim.current_animation = 'walk'
	else:
		move_dir = 0
		anim.current_animation = '[stop]'
		
	if move_dir != 0:
		velocity.x = move_dir * SPEED
	else:
		velocity.x = 0
		
	move_and_slide() 
