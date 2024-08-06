class_name MapSpawnerRiver extends MapSpawner

@export var river_map_data : RiverMapData
var object_start_offset := 0

func query_position(_params:Dictionary) -> Vector2:
	return Vector2.ZERO

# @NOTE: +1 because the loop looks _back_ at previous point for establishin vector/line
func get_loop_start_index() -> int:
	return river_map_data.starting_index_offset + object_start_offset + 1

func get_positions_within(step_bounds:Bounds) -> Array[PossibleSpawnPoint]:
	var gen := river_map_data.gen
	var center := gen.river_center
	
	var anchor_pos : Vector2
	var arr : Array[PossibleSpawnPoint] = []
	var ratio_carry_over := 0.0
	
	for i in range(get_loop_start_index(), center.size()):
		var prev_point := center[i-1]
		anchor_pos = prev_point
		
		var vec := center[i] - prev_point
		var ratio := ratio_carry_over
		while ratio < 1.0:
			var step_size := step_bounds.rand_float()
			anchor_pos += step_size * vec.normalized()
			ratio = (anchor_pos - prev_point).length() / vec.length()
			if ratio >= 1.0: 
				ratio_carry_over = ratio - 1.0
				break
			
			var width_left : float = lerp(gen.river_width_left[i-1], gen.river_width_left[i], ratio)
			var width_right : float = lerp(gen.river_width_right[i-1], gen.river_width_right[i], ratio)
			
			var offset_dir := 1 if randf() <= 0.5 else -1
			var width_relevant = width_right if offset_dir == 1 else width_left
			var final_width = offset_dir * randf() * 0.8 * width_relevant
			
			var offset_pos : Vector2 = anchor_pos + final_width * vec.normalized().rotated( 0.5 * PI)
			
			var max_radius_left : float = abs(final_width - (-width_left))
			var max_radius_right : float = abs(final_width - width_right)
			var last_point = null if arr.size() <= 0 else arr.back()
			var spawn_point := PossibleSpawnPoint.new(offset_pos, vec, last_point, max_radius_left, max_radius_right)
			arr.append(spawn_point)
			
	return arr

func get_positions_along_edges(step_bounds:Bounds) -> Array[PossibleSpawnPoint]:
	var arr : Array[PossibleSpawnPoint] = []
	arr += get_positions_along_edge(river_map_data.gen.river_bank_left, step_bounds)
	arr += get_positions_along_edge(river_map_data.gen.river_bank_right, step_bounds)
	return arr

func get_positions_along_edge(edge:Array[Vector2], step_bounds:Bounds) -> Array[PossibleSpawnPoint]:
	var last_pos : Vector2
	var arr : Array[PossibleSpawnPoint] = []
	# for every line (P0->P1)
	for i in range(1,edge.size()):
		last_pos = edge[i-1]
		var vec := edge[i] - edge[i-1]
		
		var ratio := 0.0
		# keep jumping in random chunks until we've exhausted this line (arrived somewhere near/after P1)
		# this has some "overdraw" (going further than needed), but that's fine
		while ratio < 1.0:
			var step_size := step_bounds.rand_float()
			last_pos += step_size * vec.normalized()
			
			var last_point = null if arr.size() <= 0 else arr.back()
			var sp := PossibleSpawnPoint.new(last_pos, vec, last_point)
			arr.append(sp)
			ratio = (last_pos - edge[i-1]).length() / vec.length()
	return arr
