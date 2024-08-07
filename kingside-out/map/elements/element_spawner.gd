class_name ElementSpawner extends Node2D

@export var spawner : MapSpawner
@export var decoration_scene : PackedScene
@export var ground_texture_scene : PackedScene
@export var element_scene : PackedScene
@export var rocks_scene : PackedScene
@export var water_current_scene : PackedScene
@export var map_data : RiverMapData

@export var element_garbage : ElementData
@export var element_piranha : ElementData
@export var explosion_scene : PackedScene

func preactivate() -> void:
	determine_included_types()

func determine_included_types() -> void:
	var all_types := spawner.all_elements.duplicate(false)
	var types_picked : Array[ElementData] = []
	
	# include the required types (must be present in all runs)
	for i in range(all_types.size()-1, -1, -1):
		if not all_types[i].required: continue
		types_picked.append(all_types[i])
		all_types.remove_at(i)
	
	# remove the forbidden types (they have some other functionality but do NOT randomly spawn)
	for i in range(all_types.size()-1, -1, -1):
		if not all_types[i].forbidden: continue
		all_types.remove_at(i)
	
	# the piranha is only included if, of course, the piranha itself is
	var include_piranha := GInput.get_player_count() <= 1
	if include_piranha:
		types_picked.append(element_piranha)
	
	# then fill up randomly until satisfied
	var num_types := Global.config.num_unique_element_types.rand_int()
	while types_picked.size() < num_types:
		var new_type = all_types.pick_random()
		types_picked.append(new_type)
		all_types.erase(new_type)
	
	spawner.available_elements = types_picked

func activate() -> void:
	GSignalBus.drop_element.connect(on_element_drop)
	GSignalBus.should_explode.connect(on_explosion)
	spawner.object_start_offset = Global.config.object_start_offset
	place_decorations()
	place_obstacles()
	place_elements()

# These do nothing but look pretty at the edge of the river
func place_decorations() -> void:
	var step_bounds_decoration := Global.config.decoration_step_bounds.clone().scale(Global.config.get_map_base_size())
	var spawn_points := spawner.get_positions_along_edges(step_bounds_decoration)
	
	var extreme_lines : Array[Line] = [map_data.get_start_extreme(), map_data.get_end_extreme()]
	spawn_points += spawner.get_positions_along_custom_lines(extreme_lines, step_bounds_decoration)
	
	for spawn_point in spawn_points:
		spawn_point.map_layer = "decoration"
		spawn_object(decoration_scene, spawn_point)
	
	var step_bounds_ground_texture := step_bounds_decoration.clone().scale(3.0)
	var spawn_points_tex := spawner.get_positions_along_edges(step_bounds_ground_texture)
	
	spawn_points_tex += spawner.get_positions_along_custom_lines(extreme_lines, step_bounds_ground_texture)
	
	for spawn_point in spawn_points_tex:
		spawn_point.map_layer = "bottom"
		spawn_object(ground_texture_scene, spawn_point)

# These are actual obstacles in the water; can't be picked up
func place_obstacles() -> void:
	var step_bounds_current := Global.config.water_current_step_bounds.clone().scale(Global.config.get_map_base_size())
	var spawn_points_currents := spawner.get_positions_within(step_bounds_current)
	for spawn_point in spawn_points_currents:
		spawn_point.map_layer = "water"
		spawn_object(water_current_scene, spawn_point)
	
	var step_bounds_rock := Global.config.rock_step_bounds.clone().scale(Global.config.get_map_base_size())
	var spawn_points_rocks := spawner.get_positions_within(step_bounds_rock)
	for spawn_point in spawn_points_rocks:
		spawn_object(rocks_scene, spawn_point)
		
# These are floating elements you can actually pick up, convert, spit out again
func place_elements() -> void:
	var step_bounds_element := Global.config.element_step_bounds.clone().scale(Global.config.get_map_base_size())
	var spawn_points := spawner.get_positions_within(step_bounds_element)
	for spawn_point in spawn_points:
		spawn_point.type_elem = element_garbage
		spawn_object(element_scene, spawn_point)

func spawn_object(scene:PackedScene, spawn_point:PossibleSpawnPoint) -> Node2D:
	var new_node = scene.instantiate()
	new_node.set_rotation(randf() * 2 * PI)
	
	var layer := spawn_point.map_layer if spawn_point.map_layer else "elements"
	GSignalBus.place_on_map.emit(new_node, layer)
	
	if spawn_point.river_index >= 0.0:
		map_data.subdiv.save_node_on_area(new_node, spawn_point.river_index)
	
	if new_node.has_method("from_spawn_point"):
		new_node.from_spawn_point(spawn_point)
	else:
		new_node.set_position(spawn_point.pos)
	
	if spawn_point.type_elem:
		new_node.set_type(spawn_point.type_elem)
	
	if spawn_point.force.length() > 0.03:
		new_node.apply_central_impulse(spawn_point.force)
	
	return new_node

func on_element_drop(sp:PossibleSpawnPoint) -> Node2D:
	
	if not sp.type_elem:
		sp.type_elem = spawner.available_elements.pick_random()
	
	if Global.config.area_determines_drop_type and not sp.type_forced:
		var idx_of_pos = map_data.get_index_closest_to(sp.pos, -1)
		var area := map_data.subdiv.get_area_at_index(idx_of_pos)
		sp.type_elem = area.type
	
	print("Should drop element", sp.type_elem, sp.pos, sp.force)
	return spawn_object(element_scene, sp)

func on_explosion(pos:Vector2) -> void:
	var node = explosion_scene.instantiate()
	node.set_position(pos)
	call_deferred("add_child", node)
