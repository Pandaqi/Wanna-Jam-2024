class_name ModuleElementDropper extends Node2D

var vm : ModuleVehicleManager
var spawner : ElementSpawner

signal element_dropped(e:Element)

func activate(v:ModuleVehicleManager, ec:ModuleElementConverter, em:ElementSpawner) -> void:
	vm = v
	spawner = em
	ec.available_for_drop.connect(drop)

func drop(ed:ElementData) -> void:
	var pos := get_random_position_around_us()
	var push_away_force : Vector2 = (pos - vm.get_vehicle_position()).normalized() * Global.config.get_map_base_size() * Global.config.element_drop_push_force_bounds.rand_float()
	
	var sp := PossibleSpawnPoint.new(pos)
	sp.force = push_away_force
	sp.type_elem = ed
	
	var elem_node := spawner.on_element_drop(sp) as Element
	element_dropped.emit(elem_node)

func get_random_position_around_us() -> Vector2:
	var canoe_range := (0.5 * Global.config.canoe_size.x) * 1.25 # slightly larger so it doesn't spawn inside us or something
	var speed_vec : Vector2 = vm.connected_vehicle.get_linear_velocity().normalized()
	var rand_dir := 1 if randf() <= 0.5 else -1
	var rand_angle := PI - Global.config.element_drop_forbidden_angle
	var offset_vec := speed_vec.rotated(rand_dir * rand_angle)
	
	return vm.get_vehicle_position() + offset_vec * canoe_range
	
