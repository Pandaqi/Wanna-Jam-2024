class_name RiverMapData extends Resource

var gen : RiverGenerator
var starting_index_offset := 1 # don't start at 0, as that puts us right on the edge, start a few sections later
var finish_index_offset := 2 # also don't end at the very last element; place the finish slightly before it 

func get_starting_positions(num:int) -> Array[Vector2]:
	var starting_line := Line.new(gen.river_bank_left[starting_index_offset], gen.river_bank_right[starting_index_offset])
	var arr : Array[Vector2] = []
	for i in range(num):
		# pretend there's a spot extreme left and extreme right; then skip them; this gets nicely centered positions
		var pos = starting_line.interpolate(float(i+1) / float(num+2))
		arr.append(pos)
	return arr

func get_finish_line() -> Line:
	var num := gen.count() - 1 - finish_index_offset
	return Line.new(gen.river_bank_right[num], gen.river_bank_left[num])

func get_index_closest_to(pos:Vector2, start_from:int) -> float:
	var dir := 1
	var closest_dist := INF
	var closest_index := start_from
	var closest_index_precise := start_from
	
	for i in range(gen.count()):
		var index_offset : int = floor(i/2) * dir
		var cur_index : int = start_from + index_offset
		cur_index = clamp(cur_index, 1, gen.count() - 1)
		var prev_index := cur_index - 1
		dir *= -1
		
		var prev_point := gen.river_center[prev_index]
		var cur_point := gen.river_center[cur_index]
		
		var closest_pos := Geometry2D.get_closest_point_to_segment(prev_point, cur_point, pos)
		var temp_closest_dist := (closest_pos - pos).length()
		var ratio : float = (closest_pos - prev_point).length() / (cur_point - prev_point).length()
		
		if temp_closest_dist < closest_dist:
			closest_dist = temp_closest_dist
			closest_index = cur_index
			closest_index_precise = cur_index + ratio
	
		if i > 5: break # we only need to check a few segments left/right of where we were previously, anything else SHOULD be impossible
	
	return closest_index_precise

func get_position_on_river_at(idx:float) -> Vector2:
	var idx_int : int = floor(idx)
	var anchor_point := gen.river_center[idx_int]
	var fraction : float = idx - idx_int
	var progress := (gen.river_center[idx_int + 1] - gen.river_center[idx_int]) * fraction
	return anchor_point + progress
