class_name Vehicle extends RigidBody2D


var has_finished := false

@export var connected_players : Array[Player] = []

@onready var feeler : ModuleFeeler = $Feeler
@onready var mover : ModuleVehicleMover = $Mover

signal finished()

func _ready():
	mass = Global.config.canoe_mass

func add_driver(p:Player) -> void:
	connected_players.append(p)

func remove_driver(p:Player) -> void:
	connected_players.erase(p)

func get_bounds() -> Rect2:
	var max_size : float = max(Global.config.canoe_size.x, Global.config.canoe_size.y)
	var pos := global_position
	return Rect2(pos.x - 0.5*max_size, pos.y - 0.5*max_size, max_size, max_size)
	
func finish():
	has_finished = true
	emit_signal("finished")	

func is_finished() -> bool:
	return has_finished
	
