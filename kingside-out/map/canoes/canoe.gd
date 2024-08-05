class_name Vehicle extends RigidBody2D

# how much of the impulse should be for pushing the canoe forward
# (the other part is for rotating us to the side)
var percentage_forward := 0.25
var power := 1.0

@export var inputs : Array[ModuleInput] = []

func _physics_process(dt:float) -> void:
	poll_inputs()

func poll_inputs() -> void:
	for input in inputs:
		if input.is_left(): row(-1)
		if input.is_right(): row(+1)

func row(dir:int) -> void:
	var forward_vec := Vector2.RIGHT.rotated( get_rotation() )
	var canoe_size := Vector2(20, 10)
	var final_power := power * mass
	
	var impulse_rot : float = lerp(0.0, 0.5*PI*dir, 1.0 - percentage_forward)
	var impulse_vec := forward_vec.rotated(impulse_rot) * final_power
	
	# = offset from body ORIGIN in GLOBAL coordinates
	var impulse_pos := forward_vec * 0.5 * canoe_size.x
	apply_impulse(impulse_vec, impulse_pos)
