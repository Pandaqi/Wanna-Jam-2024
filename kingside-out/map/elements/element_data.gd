extends Resource
class_name ElementData

@export_subgroup("Metadata")
@export var frame := 0
@export var processed := true
@export var color := Color(1,1,1)
@export var desc := ""

@export_subgroup("Effects")
@export var speed_change := 1.0
@export var time_change := 0.0
@export var size_change := 1.0
@export var mass_change := 1.0
@export var make_ghost := false
@export var piranha_change := 1.0
@export var explode := false

func execute(eg:ModuleElementGrabber) -> void:
	var player := eg.entity
	var vehicle := player.vehicle_manager.connected_vehicle
	
	if not is_equal_approx(time_change, 0.0): player.effects_tracker.add_time(time_change)
	GSignalBus.piranha_change.emit(piranha_change)
	
	if explode:
		GSignalBus.should_explode.emit(vehicle.global_position)
	
	if vehicle:
		if not is_equal_approx(speed_change, 1.0): vehicle.mover.change_speed_factor(speed_change)
		if not is_equal_approx(size_change, 1.0): vehicle.physics.change_scale(size_change)
		if not is_equal_approx(mass_change, 1.0): vehicle.physics.change_mass(mass_change)
		
		if make_ghost:
			vehicle.physics.set_ghost(true)
	
	var create_new_vehicle := (vehicle is VehicleSwim) and (not is_equal_approx(size_change, 1.0))
	if create_new_vehicle:
		GSignalBus.place_canoe.emit(vehicle.global_position, player)
