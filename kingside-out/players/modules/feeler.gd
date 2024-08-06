class_name ModuleFeeler extends Node2D

@onready var col_shape : CollisionShape2D = $Area2D/CollisionShape2D

signal body_entered(node:Node2D)

func activate(p:ModulePhysics):
	p.size_changed.connect(on_body_size_changed)

func _on_area_2d_body_entered(body: Node2D) -> void:
	body_entered.emit(body)

func on_body_size_changed(new_size:Vector2) -> void:
	var shp = RectangleShape2D.new()
	shp.size = new_size
	col_shape.shape = shp
