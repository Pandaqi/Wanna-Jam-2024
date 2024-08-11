class_name Piranha extends Node2D

@export var map_data : RiverMapData
@export var players_data : PlayersData

var cur_index := 0.0
var perp_line : Line
var speed_bounds : Bounds
@onready var timer_pause : Timer = $TimerPause
var paused := false

var target_element : Element
var target_vehicle : Vehicle

@onready var area_scan : Area2D = $AreaScan
@onready var col_shape_scan : CollisionShape2D = $AreaScan/CollisionShape2D
@onready var area_kill : Area2D = $AreaKill
@onready var col_shape_kill : CollisionShape2D = $AreaKill/CollisionShape2D
@onready var audio_player := $AudioStreamPlayer2D

# @TODO: all the functionality for following track, chasing player, killing them
func activate() -> void:
	speed_bounds = Global.config.piranha_speed_bounds.clone().scale(Global.config.get_map_base_size())
	GSignalBus.piranha_change.connect(on_piranha_change)
	set_correct_radii()

func set_correct_radii() -> void:
	var base_size := Global.config.get_map_base_size()
	var radius_scan := Global.config.piranha_scan_radius * base_size
	var shp_scan = CircleShape2D.new()
	shp_scan.radius = radius_scan
	col_shape_scan.shape = shp_scan
	
	var radius_kill := Global.config.piranha_kill_radius * radius_scan
	var shp_kill = CircleShape2D.new()
	shp_kill.radius = radius_kill
	col_shape_kill.shape = shp_kill

func _physics_process(dt:float) -> void:
	check_target_validity()
	move(dt)
	update_river_index()
	check_players_nearby()

func check_target_validity() -> void:
	if target_element and not is_instance_valid(target_element):
		target_element = null
	
	if target_vehicle and not is_instance_valid(target_vehicle):
		target_vehicle = null

func move(dt:float) -> void:
	if paused: return
	
	var speed := get_speed() * dt
	
	# by default, just follow the center line (to next point)
	var target_pos := map_data.gen.river_center[ceil(cur_index)]
	
	# if we know an element is near, though, head for it
	if target_element:
		target_pos = target_element.global_position
	
	# if we also know a player is near, it gets preference; head for it
	if target_vehicle:
		target_pos = target_vehicle.global_position
	
	var vec := (target_pos - global_position).normalized()
	set_position( get_position() + vec * speed )

func check_players_nearby() -> void:
	var nearest_player : Player = null
	var smallest_idx_diff : float = INF
	
	for p in players_data.players:
		var idx_diff : float = abs( p.river_tracker.get_index_on_river_float() - cur_index )
		if idx_diff > smallest_idx_diff: continue
		smallest_idx_diff = idx_diff
		nearest_player = p
	
	var too_far_away := smallest_idx_diff > 1.0
	if too_far_away: 
		target_vehicle = null
		return
	
	target_vehicle = nearest_player.vehicle_manager.connected_vehicle

func update_river_index() -> void:
	cur_index = map_data.get_index_closest_to(global_position, floor(cur_index))
	get_node("Label").set_text(str(cur_index))

func get_progress_ratio() -> float:
	return cur_index / map_data.get_max_index()

func get_speed() -> float:
	return speed_bounds.interpolate(get_progress_ratio())

func on_piranha_change(dp:float) -> void:
	var time : float = dp + max(timer_pause.time_left, 0.0)
	timer_pause.stop()
	timer_pause.wait_time = time
	timer_pause.start()
	paused = true

func _on_timer_pause_timeout() -> void:
	paused = false

func recheck_closest_element() -> void:
	var closest_elem : Element = null
	var closest_dist := INF
	for body in area_scan.get_overlapping_bodies():
		if not (body is Element): continue
		if not body.data.piranha_interested: continue
		
		var dist = body.global_position.distance_to(global_position)
		if dist >= closest_dist: continue
		closest_dist = dist
		closest_elem = body
	
	target_element = closest_elem

# Checking if we're in range of the player is done through raw vectors,
# only elements are picked up by the scan area
func _on_area_scan_body_entered(body: Node2D) -> void:
	var is_element := (body is Element)
	if not is_element: return
	recheck_closest_element()

func _on_area_kill_body_entered(body: Node2D) -> void:
	if body is Element: 
		body.kill()
		target_element = null
		recheck_closest_element()
		audio_player.volume_db = -8
		audio_player.pitch_scale = randf_range(0.9, 1.1)
	
	if body is Vehicle:
		body.kill_drivers()
		body.kill()
		target_vehicle = null
		audio_player.volume_db = 0
		audio_player.play()
