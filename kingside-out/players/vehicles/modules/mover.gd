class_name ModuleVehicleMover extends Node2D

# how much of the impulse should be for pushing the canoe forward
# (the other part is for rotating us to the side)
var percentage_forward := 0.25
var power := 5.0

@onready var entity : Vehicle = get_parent()

func _physics_process(_dt:float) -> void:
	poll_inputs()

func poll_inputs() -> void:
	for p in entity.connected_players:
		if p.input.is_left(): row(-1)
		if p.input.is_right(): row(+1)

func row(dir:int) -> void:
	var forward_vec := Vector2.RIGHT.rotated( entity.get_rotation() )
	var final_power := power * entity.mass
	
	var impulse_rot : float = lerp(0.0, 0.5*PI*dir, 1.0 - percentage_forward)
	var impulse_vec := forward_vec.rotated(impulse_rot) * final_power
	
	# = offset from body ORIGIN in GLOBAL coordinates
	var impulse_pos := forward_vec * 0.5 * Global.config.canoe_size.x
	entity.apply_impulse(impulse_vec, impulse_pos)
