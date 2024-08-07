class_name MapRiver extends Node2D

var river_generator : RiverGenerator
var river_subdivider : RiverSubdivider

@export var area_drawer_scene : PackedScene
@export var spawner : MapSpawnerRiver
@export var map_data : RiverMapData
@export var finish_line_scene : PackedScene
@onready var bodies : Node2D = $Bodies
@onready var water_texture : Node2D = $Layers/Water/WaterTexture
@onready var areas : Node2D = $Layers/Water/Areas

@onready var layers : Dictionary = {
	"bottom": $Layers/Bottom,
	"water": $Layers/Water,
	"elements": $Layers/Elements,
	"players": $Layers/Players,
	"decoration": $Layers/Decoration,
	"top": $Layers/Top
}

func activate() -> void:
	GSignalBus.place_on_map.connect(on_placement_requested)
	
	river_generator = RiverGenerator.new()
	river_subdivider = RiverSubdivider.new()
	
	map_data.gen = river_generator
	map_data.subdiv = river_subdivider
	
	regenerate()

func regenerate() -> void:
	river_generator.generate()
	queue_redraw()
	create_line_colliders()
	water_texture.update(river_generator)
	create_areas()
	create_finish()

func _draw() -> void:
	var brown_color := Color(150/255.0, 75/255.0, 0)
	draw_polyline(river_generator.river_center, Color(0,0,0), 3.0, false)
	draw_polyline(river_generator.river_bank_left, brown_color, 16.0, false)
	draw_polyline(river_generator.river_bank_right, brown_color, 16.0, false)

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

func create_areas() -> void:
	# actually generate the areas first
	river_subdivider.apply(river_generator, spawner)
	
	# then create a node to nicely display them
	for area in river_subdivider.areas:
		var a = area_drawer_scene.instantiate()
		areas.add_child(a)
		a.update(area)

func create_finish() -> void:
	var s = finish_line_scene.instantiate()
	add_child(s)
	
	var fl := map_data.get_finish_line()
	s.update(fl)

func on_placement_requested(obj, layer:String) -> void:
	add_to_layer(obj, layer)

func add_to_layer(obj, layer:String) -> void:
	layers[layer].add_child(obj)
