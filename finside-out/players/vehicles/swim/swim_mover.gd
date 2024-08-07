class_name ModuleSwimMover extends ModuleVehicleMover

var cur_angle := 0.0
var rotate_dir := 1
var ROT_SPEED := 2*PI
var rotate_locked := false
var physics : ModulePhysics

@onready var arrow : Sprite2D = $Arrow

func activate(p:ModulePhysics):
	physics = p

func _physics_process(dt:float) -> void:
	update_arrow(dt)
	poll_input()

func update_arrow(dt:float) -> void:
	var extra_angle := rotate_dir * dt * ROT_SPEED
	if rotate_locked: extra_angle = 0.0
	cur_angle += extra_angle
	arrow.set_rotation(cur_angle)
	
	var cur_scale := physics.get_size() / 512.0
	arrow.set_scale(cur_scale)
	
	var radius : float = 0.5 * physics.get_size().length()
	var new_pos := entity.global_position + Vector2.from_angle(cur_angle) * radius
	arrow.set_position(new_pos)

func get_arrow_vec() -> Vector2:
	return Vector2.from_angle(cur_angle)

func poll_input() -> void:
	if entity.connected_players.size() <= 0: return
	
	var player := entity.connected_players[0]
	var has_input := false
	rotate_locked = false
	
	if player.input.is_left(): 
		rotate_dir = -1
		has_input = true
	
	if player.input.is_right(): 
		rotate_dir = 1
		has_input = true
	
	if not has_input: return
	
	rotate_locked = true
	
	var vec := get_arrow_vec() * entity.get_mass() * Global.config.swim_vehicle_power * get_speed_factor()
	apply_impulse(vec, Vector2.ZERO)
