extends Node3D

@export var card_lifetime: float = 5.0  
@export var card_speed: float = 10.0    

var velocity: Vector3

func _physics_process(_delta: float) -> void:
	changecardtocurrent()
	
func launch(direction: Vector3, speed: float):
	velocity = direction.normalized() * speed
	$Timer.start()

func _process(delta):
	global_transform.origin += velocity * delta

func _on_timer_timeout() -> void:
	self.queue_free()

func changecardtocurrent():
	if GameManager.currentcard == 0:
		$AnimatedSprite3D.play('0')
	if GameManager.currentcard == 1:
		$AnimatedSprite3D.play('1')
