class_name MapRiver extends Node2D

var river_generator : RiverGenerator

@export var map_data : RiverMapData
@export var finish_line_scene : PackedScene
@onready var bodies : Node2D = $Bodies
@onready var water_texture : Node2D = $WaterTexture

func activate() -> void:
	river_generator = RiverGenerator.new()
	map_data.gen = river_generator
	regenerate()

func regenerate() -> void:
	river_generator.generate()
	queue_redraw()
	create_line_colliders()
	water_texture.update(river_generator)
	create_finish()

func _draw() -> void:
	draw_polyline(river_generator.river_center, Color(0,0,0), 3.0, false)
	draw_polyline(river_generator.river_bank_left, Color(1,0,0), 3.0, false)
	draw_polyline(river_generator.river_bank_right, Color(1,0,0), 3.0, false)

func _input(ev:InputEvent) -> void:
	if ev.is_action_released("ui_accept"):
		regenerate()

func create_line_colliders() -> void:
	for body in bodies.get_children():
		body.queue_free()
	
	create_line_collider(river_generator.river_bank_left)
	create_line_collider(river_generator.river_bank_right)
	
	# start and finish
	create_line_collider([river_generator.river_bank_left.front(), river_generator.river_bank_right.front()])
	create_line_collider([river_generator.river_bank_right.back(), river_generator.river_bank_left.back()])

func create_line_collider(arr:Array[Vector2]) -> void:
	var body = StaticBody2D.new()
	
	for i in range(1,arr.size()):
		var col_shape = CollisionShape2D.new()
		var seg = SegmentShape2D.new()
		seg.a = arr[i-1]
		seg.b = arr[i]
		col_shape.shape = seg
		body.add_child(col_shape)
	
	bodies.call_deferred("add_child", body)

func get_bounds() -> Rect2:
	return river_generator.bounds

func create_finish() -> void:
	var s = finish_line_scene.instantiate()
	add_child(s)
	
	var fl := map_data.get_finish_line()
	s.update(fl)
