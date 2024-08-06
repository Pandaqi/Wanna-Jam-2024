extends Node2D

var polygons : Array[PackedVector2Array] = []
var polygon_uvs : Array[PackedVector2Array] = []

func update(gen:RiverGenerator) -> void:
	polygons = []
	
	for i in range(1, gen.count()):
		var polygon : PackedVector2Array = [gen.river_bank_left[i-1], gen.river_bank_left[i], gen.river_bank_right[i], gen.river_bank_right[i-1]]
		var uvs : PackedVector2Array = []
		for point in polygon:
			var point_to_uv := (point - gen.bounds.position) / gen.bounds.size
			uvs.append(point_to_uv)
		
		polygons.append(polygon)
		polygon_uvs.append(uvs)
	
	queue_redraw()

func _draw() -> void:
	for i in range(polygons.size()):
		draw_polygon(polygons[i], [Color(0.75,0.75,1)], polygon_uvs[i])
