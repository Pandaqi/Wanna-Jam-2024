class_name ModuleVehicleMover extends Node2D

@onready var entity : Vehicle = get_parent()
var speed_factor := 1.0

func _ready() -> void:
	entity.driver_added.connect(on_driver_added)
	entity.driver_removed.connect(on_driver_removed)

func on_driver_added(_p:Player, _side:Config.CanoeControlSide) -> void:
	pass

func on_driver_removed(_p:Player):
	pass

func get_forward_vector() -> Vector2:
	return Vector2.RIGHT.rotated( entity.get_rotation() )

func get_mass() -> float:
	return entity.mass

func get_speed_factor() -> float:
	if Global.config.finish_turtle_afterwards and entity.is_finished(): return 0.1
	return speed_factor

func apply_impulse(vec:Vector2, pos:Vector2) -> void:
	entity.apply_impulse(vec, pos)

func change_speed_factor(ds:float) -> void:
	speed_factor = Global.config.speed_factor_bounds.clamp_value(speed_factor * ds)
