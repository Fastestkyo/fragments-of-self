extends Node3D
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var anim3d: AnimatedSprite3D = $AnimatedSprite3D

@export var type :int

func _ready() -> void:
	if type == 1:
		anim3d.play("shard" + str(GameManager.noshard))
	elif type == 2:
		anim3d.play("memshard" + str(GameManager.memshard))
	
	print(GameManager.noshard)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		if type == 1:
			anim.play('shard')
			GameManager.noshard += 1
			$Area3D.queue_free()
			await anim.animation_finished
			GameManager.tp_no()
			self.queue_free()
		elif type == 0:
			anim.play('shard')
			GameManager.memshard += 1
			$Area3D.queue_free()
			await anim.animation_finished
			GameManager.tp_mem()
			self.queue_free()
