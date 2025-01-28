extends Node3D
@export var anim : AnimationPlayer


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		anim.play('shard')
		GameManager.memshard += 1
		$Area3D.queue_free()
		await anim.animation_finished
		GameManager.tp_mem()
		self.queue_free()
