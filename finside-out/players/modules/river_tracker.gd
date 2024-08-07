class_name ModuleRiverTracker extends Node2D

@export var map_data : RiverMapData

var vehicle_manager : ModuleVehicleManager
var cur_index : float = 0.0

@onready var debug_label : Label = $DebugLabel

func activate(vm:ModuleVehicleManager) -> void:
	vehicle_manager = vm

func _physics_process(_dt:float) -> void:
	check_progress_on_river()

func check_progress_on_river() -> void:
	cur_index = map_data.get_index_closest_to(vehicle_manager.get_vehicle_position(), get_index_on_river_float())
	debug_label.global_position = vehicle_manager.get_vehicle_position()
	debug_label.set_text(str(cur_index))

func get_index_on_river_int() -> int:
	return floor(cur_index)

func get_index_on_river_float() -> float:
	return cur_index

func boost_along_river() -> void:
	var idx := get_index_on_river_int()
	var vec := (map_data.gen.river_center[idx + 1] - map_data.gen.river_center[idx]).normalized()
	var boost_force := Global.config.player_in_last_place_boost_force * Global.config.get_map_base_size() * Global.config.canoe_mass
	vehicle_manager.apply_force(vec * boost_force)

func get_current_area() -> RiverArea:
	return map_data.subdiv.get_area_at_index(get_index_on_river_float())
