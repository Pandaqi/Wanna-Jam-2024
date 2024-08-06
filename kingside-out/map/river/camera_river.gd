class_name CameraRiver extends Camera2D

@export var map_data : RiverMapData
@export var players_data : PlayersData

const MOVE_SPEED := 8.0
const ZOOM_SPEED := 8.0

var min_size := Vector2(512.0, 512.0 * (9.0/16.0))
var max_size := Vector2(2048.0, 2048.0 * (9.0/16.0))

var min_bounds_pos : Vector2
var max_bounds_pos : Vector2

var camera_edge_margin := Vector2(32.0, 32.0)
@export var mode := "players" # players or map

func _process(dt:float) -> void:
	var bounds : Rect2 = get_bounds()
	if not bounds: return
	
	var target_position := bounds.get_center()
	var size_bounds := Global.config.camera_size_bounds.clone().scale( Global.config.get_map_base_size() )
	
	var vp_size := get_viewport_rect().size - 2*camera_edge_margin
	var desired_size := bounds.size
	desired_size.x = max(desired_size.x, size_bounds.start)
	desired_size.y = max(desired_size.y, size_bounds.start)
	
	var too_zoomed_out := desired_size.x > size_bounds.end or desired_size.y > size_bounds.end
	if too_zoomed_out:
		print("Larger than allowed")
		players_data.get_last_place().river_tracker.boost_along_river()
	
	var ratios := vp_size / desired_size
	
	var target_zoom : Vector2 = min(ratios.x, ratios.y) * Vector2.ONE
	
	var move_factor := MOVE_SPEED*dt
	var zoom_factor := ZOOM_SPEED*dt
	set_position(get_position().lerp(target_position, move_factor))
	set_zoom(get_zoom().lerp(target_zoom, zoom_factor))

func get_bounds() -> Rect2:
	if mode == "map": return map_data.gen.bounds
	if mode == "players":
		
		# determine smallest rectangle that fits around the players
		min_bounds_pos = Vector2(INF, INF)
		max_bounds_pos = Vector2(-INF, -INF)
		
		for p in players_data.players:
			var rect = p.vehicle_manager.connected_vehicle.get_bounds()
			expand_bounds(rect)
		
		# make sure the first player can "look ahead"
		var first_player : Player = players_data.get_first_place()
		var pos_ahead := map_data.get_position_on_river_at(first_player.river_tracker.get_index_on_river_float() + Global.config.camera_num_segments_look_ahead)
		var index_ahead_rect := Rect2(pos_ahead.x, pos_ahead.y, 10, 10)
		expand_bounds(index_ahead_rect)

		return Rect2(min_bounds_pos.x, min_bounds_pos.y, max_bounds_pos.x - min_bounds_pos.x, max_bounds_pos.y - min_bounds_pos.y)
	
	# fallback return to make type checker happy
	return map_data.gen.bounds

func expand_bounds(rect:Rect2) -> void:
	min_bounds_pos.x = min(min_bounds_pos.x, rect.position.x)
	min_bounds_pos.y = min(min_bounds_pos.y, rect.position.y)
	max_bounds_pos.x = max(max_bounds_pos.x, rect.position.x + rect.size.x)
	max_bounds_pos.y = max(max_bounds_pos.y, rect.position.y + rect.size.y)
