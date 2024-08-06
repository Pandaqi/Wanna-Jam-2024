class_name Config extends Resource

@export_subgroup("General Map")
@export var canoe_size := Vector2(128.0, 64.0)
@export var canoe_mass := 100.0
@export var map_size_scalar := 12.0 # multiplied by canoe_size.y later; conceptually, this is the real pixel width/length of the starting line (where all canoes are stacked vertically)
var camera_size_bounds := Bounds.new(1.0, 3.75) # ~map_size => good bounds are probably near 3.5-4.0
var camera_num_segments_look_ahead := 3
var object_start_offset := 1

@export_subgroup("River Generation")
@export var river_max_tries_before_give_up := 20
@export var river_max_rotation_per_step := 0.15*PI
@export var target_river_length := 2.0 # ~map_size
@export var river_width_def := 0.5 # ~map_size
var river_width_bounds := Bounds.new(0.33, 1.25) # ~width_def
# @NOTE: can't be too large, as that leads to spiky routes and possibly overlap/errors in sprite creation
var river_width_change_bounds := Bounds.new(0.3, 0.5) # ~width_def
var river_step_dist_bounds := Bounds.new(0.5, 0.6) # ~map_size
var river_bend_change_bounds := Bounds.new(3.0, 10.0) # the river will keep bending in the same direction for several steps (prettier and more organic); these bounds indicate when it will randomly switch

#@export_subgroup("Obstacles")
var water_current_radius := Bounds.new(0.125, 0.225) # ~map_size
var water_current_strength := Bounds.new(150.0, 250.0) # ~canoe_mass
var water_current_step_bounds := Bounds.new(0.2, 0.5)
@export var water_current_scroll_speed := 0.5
@export var water_current_shader_scale := 1.75
@export var water_current_backwards_strength_modifier := 0.33

var rocks_radius := Bounds.new(0.01, 0.075) # ~map_size
var rock_step_bounds := Bounds.new(0.075, 0.2)

#@export_subgroup("Decorations")
var decoration_step_bounds := Bounds.new(0.05, 0.1)

#@export_subgroup("Elements")
var element_step_bounds := Bounds.new(0.3, 0.6)
var element_drop_push_force_bounds := Bounds.new(0.175, 0.33) # ~map_size
var element_drop_forbidden_angle := 0.5 * PI # they always go to the side or backward

var finish_width := 0.775 # ~canoe_size.x
var player_in_last_place_boost_force := 0.5 # ~map_size

var conversion_duration_bounds := Bounds.new(0.3, 1.0)

func get_map_base_size() -> float:
	return map_size_scalar * canoe_size.y
