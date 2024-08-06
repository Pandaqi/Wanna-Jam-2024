class_name RiverArea extends Node

var type:ElementData
var polygons : Array[PackedVector2Array] = []

func _init(tp:ElementData) -> void:
	type = tp

func add_polygon(poly:PackedVector2Array) -> void:
	polygons.append(poly)

func count() -> int:
	return polygons.size()
