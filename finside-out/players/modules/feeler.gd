class_name ModuleFeeler extends Node2D

@onready var area : Area2D = $Area2D
@onready var col_shape : CollisionShape2D = $Area2D/CollisionShape2D

@onready var entity : Vehicle = get_parent()

var physics : ModulePhysics
@export var accepted_types : Array[ElementData] = []

signal body_entered(node:Node2D)

func activate(p:ModulePhysics):
	physics = p
	p.size_changed.connect(on_body_size_changed)
	entity.driver_added.connect(player_added)
	entity.driver_removed.connect(player_removed)

func player_added(p:Player, _side:Config.CanoeControlSide) -> void:
	p.element_grabber.exclusion_ended.connect(on_exclusion_ended)

func player_removed(p:Player) -> void:
	p.element_grabber.exclusion_ended.disconnect(on_exclusion_ended)

func on_exclusion_ended(_body) -> void:
	recheck_area()

func recheck_area() -> void:
	for body in area.get_overlapping_bodies():
		_on_area_2d_body_entered(body)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if physics.ghost: return
	if (body is Element) and not is_accepted(body.data): return
	body_entered.emit(body)

func is_accepted(data:ElementData) -> bool:
	return accepted_types.size() <= 0 or accepted_types.has(data)

func on_body_size_changed(new_size:Vector2) -> void:
	call_deferred("resize_shape", new_size)

func resize_shape(new_size:Vector2) -> void:
	var shp = RectangleShape2D.new()
	shp.size = new_size
	col_shape.shape = shp
