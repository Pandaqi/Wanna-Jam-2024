class_name RiverSubdivider extends Node

var areas : Array[RiverArea] = []
var area_indices : Array[int] = [] # links the index of a point on the river to the id of its area

func apply(gen:RiverGenerator, spawner:MapSpawnerRiver):
	var cur_area : RiverArea = null
	var desired_area_size := 0
	for i in range(gen.count() - 1):
		
		# start a new area if needed
		if not cur_area:
			var type = spawner.all_elements.pick_random()
			desired_area_size = Global.config.area_size_bounds.rand_int()
			cur_area = RiverArea.new(type)
			areas.append(cur_area)
		
		# fill it with the current polygon
		var poly : PackedVector2Array = [
			gen.river_bank_left[i], gen.river_bank_left[i+1],
			gen.river_bank_right[i+1], gen.river_bank_right[i]
		]
		
		cur_area.add_polygon(poly)
		area_indices.append(areas.size() - 1) # remember this point is linked to the current area
		
		# if we've become big enough, reset for a new area 
		if cur_area.count() >= desired_area_size:
			cur_area = null

func get_area_at_index(idx:float) -> RiverArea:
	var idx_conv := area_indices[idx]
	return areas[idx_conv]
