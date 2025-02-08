extends StaticBody3D

func open():
	call_deferred("_open")

func _open():
	$CollisionShape3D.disabled = true 
	$MeshInstance3D.visible = false   

func close():
	call_deferred("_close")

func _close():
	$CollisionShape3D.disabled = false 
	$MeshInstance3D.visible = true    
