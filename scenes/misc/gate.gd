extends StaticBody3D

func open():
	call_deferred("_open")

func _open():
	$CollisionShape3D.disabled = true  # Disable collision to allow passage
	$MeshInstance3D.visible = false     # Make the gate invisible

func close():
	call_deferred("_close")

func _close():
	$CollisionShape3D.disabled = false  # Enable collision to block passage
	$MeshInstance3D.visible = true      # Make the gate visible
