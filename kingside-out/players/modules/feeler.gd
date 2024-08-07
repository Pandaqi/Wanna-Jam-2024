class_name ModuleFeeler extends Node2D

@onready var col_shape : CollisionShape2D = $Area2D/CollisionShape2D

var physics : ModulePhysics
@export var accepted_types : Array[ElementData] = []

signal body_entered(node:Node2D)

func activate(p:ModulePhysics):
	physics = p
	p.size_changed.connect(on_body_size_changed)

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
