class_name Ball
extends RigidBody3D

@export var hold_position: Vector3
var on_ground: bool = true

func _throw(power: float, zFacing: float) -> void:
	print("throw")
	set_freeze_enabled(false)
	linear_velocity += Vector3(0, power/5.0, power*zFacing)

func _pickup() -> void:
	print("pick up")

# step 5
	on_ground = false
# step 10
	position = hold_position
# freezes the ball in place
	linear_velocity = Vector3.ZERO
	set_freeze_enabled(true)

#changes ball color
	var newMaterial = StandardMaterial3D.new()
	newMaterial.albedo_color = Color(1,0,0,1)
	get_node("MeshInstance3D").material_override = newMaterial
