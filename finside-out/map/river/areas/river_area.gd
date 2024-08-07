class_name RiverArea extends Node

var type:ElementData
var polygons : Array[PackedVector2Array] = []
var nodes_inside : Array = []

signal area_changed()

func _init(tp:ElementData) -> void:
	type = tp

func add_node(n) -> void:
	nodes_inside.append(n)
	area_changed.emit()

func add_polygon(poly:PackedVector2Array) -> void:
	polygons.append(poly)
	area_changed.emit()

func count() -> int:
	return polygons.size()
