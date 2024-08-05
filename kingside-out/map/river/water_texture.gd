extends Node2D

var polygons : Array[PackedVector2Array] = []
var polygon_uvs : Array[PackedVector2Array] = []

func update(bounds:Rect2, bank_left:Array[Vector2], bank_right:Array[Vector2]) -> void:
	polygons = []
	for i in range(1, bank_left.size()):
		var polygon : PackedVector2Array = [bank_left[i-1], bank_left[i], bank_right[i], bank_right[i-1]]
		var uvs : PackedVector2Array = []
		for point in polygon:
			var point_to_uv := (point - bounds.position) / bounds.size
			uvs.append(point_to_uv)
		
		polygons.append(polygon)
		polygon_uvs.append(uvs)
	queue_redraw()

func _draw() -> void:
	for i in range(polygons.size()):
		draw_polygon(polygons[i], [Color(0.75,0.75,1)], polygon_uvs[i])
