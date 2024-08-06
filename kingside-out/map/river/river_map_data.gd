class_name RiverMapData extends Resource

var gen : RiverGenerator
var subdiv : RiverSubdivider
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

# @NOTE: If a boat is at index "1", it means the closest track point _behind us_ has index 1
# Another Example: If at "1.5" it means we're halfway between points 1 and 2 on the center line
func get_index_closest_to(pos:Vector2, start_from:int = -1) -> float:
	var dir := 1
	var closest_dist := INF
	var closest_index_precise : float = start_from
	
	var check_all = start_from < 0
	
	for i in range(gen.count()):
		var index_offset : int = floor(i/2) * dir
		if check_all: index_offset = i
		
		var cur_index : int = start_from + index_offset
		cur_index = clamp(cur_index, 0, gen.count() - 1 - 1)
		var next_index := cur_index + 1
		dir *= -1
		
		var cur_point := gen.river_center[cur_index]
		var next_point := gen.river_center[next_index]
		
		var closest_pos := Geometry2D.get_closest_point_to_segment(cur_point, next_point, pos)
		var temp_closest_dist := (closest_pos - pos).length()
		var ratio : float = (closest_pos - cur_point).length() / (next_point - cur_point).length()
		
		if temp_closest_dist < closest_dist:
			closest_dist = temp_closest_dist
			closest_index_precise = cur_index + ratio
	
		# if we start from a known (correct) index, we only need to check a few segments left/right of where we were previously, anything else SHOULD be impossible
		if (not check_all) and (i > 5): break 
	
	return closest_index_precise

func get_position_on_river_at(idx:float) -> Vector2:
	var idx_int : int = floor(idx)
	var anchor_point := gen.river_center[clamp(idx_int, 0, gen.count() - 1)]
	var next_point := gen.river_center[clamp(idx_int + 1, 0, gen.count()-1)]
	var fraction : float = idx - idx_int
	var progress := (next_point - anchor_point) * fraction
	return anchor_point + progress
