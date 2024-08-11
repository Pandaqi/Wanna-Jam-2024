extends Node2D

var area : RiverArea

@export var tutorial_scene : PackedScene

func _ready() -> void:
	material = material.duplicate(false)

func update(ra:RiverArea) -> void:
	area = ra
	area.area_changed.connect(on_area_changed)
	on_area_changed()

func on_area_changed() -> void:
	
	material.set_shader_parameter("color", area.type.color)
	for node in area.nodes_inside:
		node.modulate = area.type.color
	
	update_tutorial()
	queue_redraw()

func update_tutorial() -> void:
	var start_poly := area.polygons[0]
	var highest_start_pos = start_poly[0]
	var flip_arrow := false
	if start_poly[3].y < highest_start_pos.y:
		highest_start_pos = start_poly[3]
		flip_arrow = true
	
	var t = tutorial_scene.instantiate()
	t.set_position(highest_start_pos)
	GSignalBus.place_on_map.emit(t, "top")
	t.set_data(area.type, flip_arrow)

func _draw():
	var col := area.type.color
	col.a = randf() # @DEBUGGING
	var num_polys := area.count()
	for i in range(num_polys):
		var polygon := area.polygons[i]
		var x_coordinate := (i+1)/float(num_polys)
		var uvs : PackedVector2Array = [Vector2(0,0), Vector2(x_coordinate,0), Vector2(x_coordinate,1), Vector2(0,1)]
		draw_polygon(polygon, [col], uvs)
