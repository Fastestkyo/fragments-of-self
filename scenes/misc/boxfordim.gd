extends MeshInstance3D

func _ready():
	update()

func _physics_process(delta: float) -> void:
	if GameManager and GameManager.currentdim != GameManager.lastdim:
		GameManager.lastdim = GameManager.currentdim
		update()

	checkplayerinside()

func update():
	var is_disabled = (GameManager.currentdim == 0) 
	$StaticBody3D/CollisionShape3D.disabled = is_disabled
	self.visible = !is_disabled

func checkplayerinside():
	if $StaticBody3D/CollisionShape3D.disabled:
		return 
	for body in $Area3D.get_overlapping_bodies():
		if body.name == "player":
			print("aspduaoisida")
			body.death() 
