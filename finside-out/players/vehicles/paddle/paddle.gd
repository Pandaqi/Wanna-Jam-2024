class_name Paddle extends Node2D

@export var is_right := false
var connected_players : Array[Player] = []
var recovering := false
var last_recover_time := 0.0
var last_input_reset_time := 0.0
var is_moving := false

@onready var timer : Timer = $Timer
@onready var mover : ModuleVehicleMover = get_parent()
@onready var audio_player := $AudioStreamPlayer2D

func _physics_process(_dt:float) -> void:
	poll_inputs()

func add_player(p:Player) -> void:
	connected_players.append(p)

func remove_player(p:Player) -> void:
	connected_players.erase(p)

func poll_inputs() -> void:
	for p in connected_players:
		var key_pressed := p.input.is_right() if is_right else p.input.is_left()
		if not key_pressed: 
			last_input_reset_time = Time.get_ticks_msec()
			is_moving = false
			return
		
		var should_respond := should_respond_to_input()
		if not should_respond: return
		
		var dir := 1 if is_right else -1
		row(dir)

func row(dir:int) -> void:
	var forward_vec := mover.get_forward_vector()
	var final_power := Global.config.canoe_vehicle_power * mover.get_mass() * mover.get_speed_factor()
	if is_perfect_timing():
		final_power *= Global.config.canoe_perfect_timing_reward
	
	var impulse_rot : float = lerp(0.0, 0.5*PI*dir, 1.0 - Global.config.canoe_percentage_forward)
	var impulse_vec := forward_vec.rotated(impulse_rot) * final_power
	
	# = offset from body ORIGIN in GLOBAL coordinates
	var impulse_pos := forward_vec * 0.5 * Global.config.canoe_size.x
	mover.apply_impulse(impulse_vec, impulse_pos)
	
	start_timer()
	
	var was_moving := is_moving
	if not was_moving:
		audio_player.pitch_scale = randf_range(0.9, 1.1)
		audio_player.play()
	
	is_moving = true

func start_timer() -> void:
	timer.wait_time = Global.config.canoe_timer_duration
	timer.start()

func _on_timer_timeout() -> void:
	last_recover_time = Time.get_ticks_msec()
	recovering = false

func should_respond_to_input() -> bool:
	var mode := Global.config.canoe_movement_mode
	if mode == Config.CanoeMovementMode.CONTINUOUS: return true
	if mode == Config.CanoeMovementMode.DISCRETE:
		return not recovering
	return false

# If the last timestamp before we toggled the input ON again ...
# Is very close to the timestamp when our paddle recharged/recovered ...
# Then we have perfect timing on the next stroke
func is_perfect_timing() -> bool:
	var time_error_seconds : float = abs(last_input_reset_time - last_recover_time) / 1000.0
	return time_error_seconds <= Global.config.canoe_timer_perfect_threshold
