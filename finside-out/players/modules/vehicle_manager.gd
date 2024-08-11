class_name ModuleVehicleManager extends Node2D

@export var connected_vehicle : Vehicle
@onready var audio_player := $AudioStreamPlayer2D
var last_known_bounds : Rect2

signal connected(v:Vehicle)
signal released(v:Vehicle)

signal finished()

func activate() -> void:
	pass

func connect_to(v:Vehicle, kill_old := false) -> void:
	if is_active(): 
		play_audio()
		release(kill_old)

	connected_vehicle = v
	connected_vehicle.add_driver(get_parent(), Config.CanoeControlSide.BOTH)
	connected_vehicle.finished.connect(on_finished)
	connected.emit(v)

func release(kill_old := false) -> void:
	if connected_vehicle:
		play_audio()
	
	var v = connected_vehicle
	connected_vehicle.remove_driver(get_parent())
	connected_vehicle.finished.disconnect(on_finished)
	connected_vehicle = null
	released.emit(v)
	
	if kill_old: 
		v.kill()

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

func play_audio() -> void:
	audio_player.pitch_scale = randf_range(0.92, 1.08)
	audio_player.play()

func get_bounds() -> Rect2:
	if connected_vehicle and is_instance_valid(connected_vehicle): 
		var bds := connected_vehicle.get_bounds()
		last_known_bounds = bds
		return bds
	return last_known_bounds
