extends Node2D

const MAX_TRIES_PER_RIVER := 20

var target_river_length := 1500.0
var step_dist := 40.0
var max_rotation_per_step := 0.15*PI
var river_width := 32.0
var river_width_bounds := Bounds.new(16.0, 60.0)
var river_width_change_bounds := Bounds.new(1.0, 4.0) # can't be too large, as that leads to spiky routes and possibly overlap/errors in sprite creation
var river_bend_change_bounds := Bounds.new(3.0, 10.0) # the river will keep bending in the same direction for several steps (prettier and more organic); these bounds indicate when it will randomly switch

var river_center : Array[Vector2] = []
var river_bank_left : Array[Vector2] = []
var river_bank_right : Array[Vector2] = []

@onready var bodies : Node2D = $Bodies
@onready var water_texture : Node2D = $WaterTexture

var total_river_length := 0.0
var bounds : Rect2

func _ready() -> void:
	regenerate()

func regenerate() -> void:
	var bad_river := true
	while bad_river:
		bad_river = not generate_river()

# Returns if it was a success or not
func generate_river() -> bool:
	var cur_width_left := RiverWidthChanger.new(river_width, river_width_bounds, river_width_change_bounds)
	var cur_width_right := RiverWidthChanger.new(river_width, river_width_bounds, river_width_change_bounds)
	var cur_bend := RiverBendChanger.new(river_bend_change_bounds)
	
	total_river_length = 0.0
	river_center = [Vector2.ZERO]
	river_bank_left = [Vector2.UP*cur_width_left.get_value()]
	river_bank_right = [Vector2.DOWN*cur_width_right.get_value()]
	
	var last_pos : Vector2 = river_center.back()
	
	while total_river_length < target_river_length:
		
		var prev_vec := Vector2.RIGHT
		if river_center.size() >= 2:
			prev_vec = last_pos - river_center[river_center.size() - 2]
		
		cur_width_left.pick_next_value()
		cur_width_right.pick_next_value()
		
		var new_step_dist := step_dist
		var new_max_rotation_per_step := max_rotation_per_step
		var new_bend := cur_bend.pick_next_value()
		
		var next_pos : Vector2
		var bank_left : Vector2
		var bank_right : Vector2
		
		var invalid_position := true
		var num_tries := 0
		while invalid_position:
			invalid_position = false
			
			var rot := randf_range(0,1) * new_bend * new_max_rotation_per_step
			var new_vec := prev_vec.normalized().rotated(rot)
			
			next_pos = last_pos + new_vec * new_step_dist
			bank_left = next_pos + new_vec.rotated(-0.5*PI) * cur_width_left.get_value()
			bank_right = next_pos + new_vec.rotated(0.5*PI) * cur_width_right.get_value()
			
			invalid_position = lines_intersect_river([
				Line.new(last_pos, next_pos),
				Line.new(river_bank_left.back(), bank_left),
				Line.new(river_bank_right.back(), bank_right)
			])
		
			# if it's not valid, change our parameters to make it more likely we find something next time
			if invalid_position:
				cur_width_left.scale_value(0.95)
				cur_width_right.scale_value(0.95)
				new_step_dist *= 0.95
				new_max_rotation_per_step *= 1.05
			
			num_tries += 1
			var no_solution_possible := num_tries >= MAX_TRIES_PER_RIVER
			if no_solution_possible:
				return false
		
		river_center.append(next_pos)
		river_bank_left.append(bank_left)
		river_bank_right.append(bank_right)
		
		total_river_length += new_step_dist
		last_pos = next_pos
	
	queue_redraw()
	cache_river_bounds()
	create_line_colliders()
	water_texture.update(bounds, river_bank_left, river_bank_right)
	return true

func lines_intersect_river(lines:Array[Line]) -> bool:
	for line in lines:
		if line_intersects_river(line): return true
	return false

func line_intersects_river(line:Line) -> bool:
	# @NOTE: -1 because we already check the next point for lines, then -1 again because we don't want to intersect on the shared point where we're coming from
	for i in range(1,river_center.size()-1):
		var line_center = Line.new(river_center[i-1], river_center[i])
		if Geometry2D.segment_intersects_segment(line.start, line.end, line_center.start, line_center.end): 
			return true
		
		var line_left = Line.new(river_bank_left[i-1], river_bank_left[i])
		if Geometry2D.segment_intersects_segment(line.start, line.end, line_left.start, line_left.end): return true
		
		var line_right = Line.new(river_bank_right[i-1], river_bank_right[i])
		if Geometry2D.segment_intersects_segment(line.start, line.end, line_right.start, line_right.end): return true
	return false

func cache_river_bounds() -> void:
	var min := Vector2(INF, INF)
	var max := Vector2(-INF, -INF)
	for i in range(river_center.size()):
		min.x = min(river_bank_left[i].x, river_bank_right[i].x, min.x)
		min.y = min(river_bank_left[i].y, river_bank_right[i].y, min.y)
		max.x = max(river_bank_left[i].x, river_bank_right[i].x, max.x)
		max.y = max(river_bank_left[i].y, river_bank_right[i].y, max.y)
	bounds = Rect2(min.x, min.y, max.x - min.x, max.y - min.y)

func _draw() -> void:
	draw_polyline(river_center, Color(0,0,0), 3.0, false)
	draw_polyline(river_bank_left, Color(1,0,0), 3.0, false)
	draw_polyline(river_bank_right, Color(1,0,0), 3.0, false)

func _input(ev:InputEvent) -> void:
	if ev.is_action_released("ui_accept"):
		regenerate()

func create_line_colliders() -> void:
	for body in bodies.get_children():
		body.queue_free()
	
	create_line_collider(river_bank_left)
	create_line_collider(river_bank_right)
	
	var b = preload("res://map/river/test_ball.tscn").instantiate()
	b.set_position(river_center.pick_random())
	add_child(b)

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
