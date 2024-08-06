class_name ModuleVehicleMover extends Node2D

@onready var entity : Vehicle = get_parent()

@onready var paddle_left : Paddle = $PaddleLeft
@onready var paddle_right : Paddle = $PaddleRight

func _ready():
	entity.driver_added.connect(on_driver_added)
	entity.driver_removed.connect(on_driver_removed)

func on_driver_added(p:Player, side:Config.CanoeControlSide) -> void:
	if side == Config.CanoeControlSide.LEFT or side == Config.CanoeControlSide.BOTH:
		paddle_left.add_player(p)
	
	if side == Config.CanoeControlSide.RIGHT or side == Config.CanoeControlSide.BOTH:
		paddle_right.add_player(p)

func on_driver_removed(p:Player):
	paddle_left.remove_player(p)
	paddle_right.remove_player(p)

func get_forward_vector() -> Vector2:
	return Vector2.RIGHT.rotated( entity.get_rotation() )

func get_mass() -> float:
	return entity.mass

func apply_impulse(vec:Vector2, pos:Vector2) -> void:
	entity.apply_impulse(vec, pos)
