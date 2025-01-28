extends Node3D
@export var anim : AnimationPlayer
@export var type:int

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		if type = 1
		anim.play('shard')
		GameManager.memshard += 1
		$Area3D.queue_free()
		await anim.animation_finished
		GameManager.tp_mem()
		self.queue_free()
