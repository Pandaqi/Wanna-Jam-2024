class_name ElementSpawner extends Node2D

@export var spawner : MapSpawner
@export var decoration_scene : PackedScene
@export var element_scene : PackedScene
@export var rocks_scene : PackedScene
@export var water_current_scene : PackedScene

@export var element_garbage : ElementData

func activate() -> void:
	spawner.object_start_offset = Global.config.object_start_offset
	place_decorations()
	place_obstacles()
	place_elements()

# These do nothing but look pretty at the edge of the river
func place_decorations() -> void:
	var step_bounds_decoration := Global.config.decoration_step_bounds.clone().scale(Global.config.get_map_base_size())
	var spawn_points := spawner.get_positions_along_edges(step_bounds_decoration)
	for spawn_point in spawn_points:
		spawn_object(decoration_scene, spawn_point)

# These are actual obstacles in the water; can't be picked up
func place_obstacles() -> void:
	var step_bounds_current := Global.config.water_current_step_bounds.clone().scale(Global.config.get_map_base_size())
	var spawn_points_currents := spawner.get_positions_within(step_bounds_current)
	for spawn_point in spawn_points_currents:
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
	add_child(new_node)
	
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
	print("Should drop element", sp.type_elem, sp.pos, sp.force)
	return spawn_object(element_scene, sp)
