extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Rotates self around the x-axis
	basis = Basis.from_euler(Vector3(PI, 0, 0)) * basis
	
	# Unrotate
	basis = Basis.from_euler(Vector3(PI, 0, 0)).inverse() * basis
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
