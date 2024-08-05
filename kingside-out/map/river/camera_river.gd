extends Camera2D

# @NOTE: this is just a temporary script for debugging river generation

const MOVE_SPEED := 8.0
const ZOOM_SPEED := 8.0

var camera_edge_margin := Vector2(32.0, 32.0)
var mode := "players" # players or map

func _process(dt:float) -> void:
	var bounds : Rect2
	
	if mode == "map":
		bounds = get_parent().get_node("Map").bounds
	if mode == "players":
		var margin := 100.0
		var player0 = get_tree().get_nodes_in_group("Players")[0]
		var pos = player0.get_node("VehicleManager").connected_vehicle.global_position
		bounds = Rect2(pos.x-margin, pos.y-margin, 2*margin, 2*margin)
		
	if not bounds: return
	
	var target_position := bounds.get_center()
	
	var vp_size := get_viewport_rect().size - 2*camera_edge_margin
	var map_size := bounds.size
	var ratios := vp_size / map_size
	
	var target_zoom : Vector2 = min(ratios.x, ratios.y) * Vector2.ONE
	
	var move_factor := MOVE_SPEED*dt
	var zoom_factor := ZOOM_SPEED*dt
	set_position(get_position().lerp(target_position, move_factor))
	set_zoom(get_zoom().lerp(target_zoom, zoom_factor))
