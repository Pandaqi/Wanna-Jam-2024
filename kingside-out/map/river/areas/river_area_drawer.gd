extends Node2D

var area : RiverArea

@onready var tutorial : Node2D = $Tutorial

func update(ra:RiverArea) -> void:
	area = ra
	
	update_tutorial()
	queue_redraw()

func update_tutorial() -> void:
	var start_poly := area.polygons[0]
	var highest_start_pos = start_poly[0]
	if start_poly[3].y < highest_start_pos.y:
		highest_start_pos = start_poly[3]
	tutorial.global_position = highest_start_pos
	tutorial.z_index = 3000

func _draw():
	var col := area.type.color
	col.a = randf() # @DEBUGGING
	var num_polys := area.count()
	for i in range(num_polys):
		var polygon := area.polygons[i]
		var x_coordinate := (i+1)/float(num_polys)
		var uvs : PackedVector2Array = [Vector2(0,0), Vector2(x_coordinate,0), Vector2(x_coordinate,1), Vector2(0,1)]
		draw_polygon(polygon, [col], uvs)
