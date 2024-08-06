class_name ModuleVehicleManager extends Node

@export var connected_vehicle : Vehicle

signal connected(v:Vehicle)
signal released(v:Vehicle)

signal finished()

func activate() -> void:
	pass

func connect_to(v:Vehicle) -> void:
	connected_vehicle = v
	connected_vehicle.add_driver(get_parent(), Config.CanoeControlSide.BOTH)
	connected_vehicle.finished.connect(on_finished)
	connected.emit(v)

func release() -> void:
	var v = connected_vehicle
	connected_vehicle.remove_driver(get_parent())
	connected_vehicle.finished.disconnect(on_finished)
	connected_vehicle = null
	released.emit(v)

func on_finished() -> void:
	finished.emit()

func get_vehicle_position() -> Vector2:
	if not is_active(): return Vector2.ZERO
	return connected_vehicle.global_position

func is_active() -> bool:
	return connected_vehicle != null

func apply_force(force:Vector2) -> void:
	if not is_active(): return
	connected_vehicle.apply_central_force(force)
