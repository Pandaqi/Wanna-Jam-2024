class_name RiverSubdivider extends Node

var areas : Array[RiverArea] = []
var area_indices : Array[int] = [] # links the index of a point on the river to the id of its area

func apply(gen:RiverGenerator, spawner:MapSpawnerRiver):
	var cur_area : RiverArea = null
	var desired_area_size := 0
	var prev_type : ElementData = null
	for i in range(gen.count() - 1):
		
		# start a new area if needed
		if not cur_area:
			var rand_idx = randi() % spawner.available_elements.size()
			var type = spawner.available_elements[rand_idx]
			
			# never do the same type twice in a row; just pick the next one if so
			if type == prev_type:
				rand_idx = (rand_idx + 1) % spawner.available_elements.size()
				type = spawner.available_elements[rand_idx]
			
			desired_area_size = Global.config.area_size_bounds.rand_int()
			cur_area = RiverArea.new(type)
			areas.append(cur_area)
			prev_type = type
		
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
	
	# don't forget the loop only goes to the second to last element, so just add the final area to the final element here
	area_indices.append(areas.size() - 1)

func get_area_at_index(idx:float) -> RiverArea:
	var idx_conv := area_indices[floor(idx)]
	return areas[idx_conv]

func save_node_on_area(node, idx:float) -> void:
	var area = get_area_at_index(idx)
	area.add_node(node)
