class_name Vehicle extends RigidBody2D

var has_finished := false

@export var connected_players : Array[Player] = []

@onready var feeler : ModuleFeeler = $Feeler
@onready var mover : ModuleVehicleMover = $Mover
@onready var physics : ModulePhysics = $Physics
@onready var visuals : ModuleVehicleVisuals = $Visuals

signal driver_added(p:Player, side:Config.CanoeControlSide)
signal driver_removed(p:Player)
signal finished()

func activate():
	visuals.activate(physics)
	feeler.activate(physics)
	physics.activate()

func add_driver(p:Player, side:Config.CanoeControlSide) -> void:
	connected_players.append(p)
	driver_added.emit(p, side)

func remove_driver(p:Player) -> void:
	connected_players.erase(p)
	driver_removed.emit(p)

func get_bounds() -> Rect2:
	var max_size : float = max(Global.config.canoe_size.x, Global.config.canoe_size.y)
	var pos := global_position
	return Rect2(pos.x - 0.5*max_size, pos.y - 0.5*max_size, max_size, max_size)
	
func finish():
	has_finished = true
	finished.emit()

func is_finished() -> bool:
	return has_finished
	
