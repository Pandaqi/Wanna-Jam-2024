class_name Config extends Resource

@export_subgroup("General Map")
@export var canoe_size := Vector2(128.0, 64.0)
@export var canoe_body_bevel := 2.0
@export var canoe_mass := 100.0
@export var sprite_base_size := 512.0 # all sprites are originally 512x512
@export var map_size_scalar := 12.0 # multiplied by canoe_size.y later; conceptually, this is the real pixel width/length of the starting line (where all canoes are stacked vertically)
var camera_size_bounds := Bounds.new(1.0, 3.75) # ~map_size => good bounds are probably near 3.5-4.0
var camera_num_segments_look_ahead := 1
var object_start_offset := 1
var ground_texture_size_bounds := Bounds.new(0.15, 0.4)

@export_subgroup("River Generation")
@export var river_max_tries_before_give_up := 20
var river_rotation_per_step_bounds := Bounds.new(0.035*PI, 0.175*PI)
@export var target_river_length := 2.0 # ~map_size
@export var river_width_def := 0.5 # ~map_size
var river_width_bounds := Bounds.new(0.33, 1.25) # ~width_def
# @NOTE: can't be too large, as that leads to spiky routes and possibly overlap/errors in sprite creation
var river_width_change_bounds := Bounds.new(0.3, 0.5) # ~width_def
var river_step_dist_bounds := Bounds.new(0.5, 0.6) # ~map_size
var river_bend_change_bounds := Bounds.new(8.0, 15.0) # the river will keep bending in the same direction for several steps (prettier and more organic); these bounds indicate when it will randomly switch

#@export_subgroup("Obstacles")
var water_current_radius := Bounds.new(0.125, 0.225) # ~map_size
var water_current_strength := Bounds.new(20.0, 25.0) # ~canoe_mass * power
var water_current_step_bounds := Bounds.new(0.2, 0.5)
@export var water_current_scroll_speed := 0.5
@export var water_current_shader_scale := 1.75
@export var water_current_backwards_strength_modifier := 0.1 # at full 180 degrees backward, it only uses 10% of normal strength

var rocks_radius := Bounds.new(0.01, 0.075) # ~map_size
var rock_step_bounds := Bounds.new(0.075, 0.2)
var rocks_health_per_radius := 5.0
var rocks_damage_per_velocity := 0.5
var rocks_can_be_destroyed := true
var rocks_spawn_random_elements := true

#@export_subgroup("Decorations")
var decoration_step_bounds := Bounds.new(0.025, 0.075)
var decoration_scale_bounds := Bounds.new(0.7, 1.5) # ~step_bounds
var tutorial_size := 0.175 # ~map_size

#@export_subgroup("Elements")
var element_step_bounds := Bounds.new(0.3, 0.6)
var element_drop_push_force_bounds := Bounds.new(0.275, 0.375) # ~map_size
var element_drop_forbidden_angle := 0.5 * PI # they always go to the side or backward
var element_size_bounds := Bounds.new(0.05, 0.075)

var finish_width := 0.775 # ~canoe_size.x
var player_in_last_place_boost_force := 0.5 # ~map_size

var conversion_duration_bounds := Bounds.new(0.3, 1.0)

var area_size_bounds := Bounds.new(1,2)
var area_determines_drop_type := true

var ghost_effect_duration := 5.0

#
# CANOE
#
enum CanoeMovementMode
{
	CONTINUOUS,
	DISCRETE
}

enum CanoeControlSide
{
	LEFT,
	RIGHT,
	BOTH
}

@export var canoe_timer_duration := 0.5
@export var canoe_movement_mode := CanoeMovementMode.CONTINUOUS
@export var canoe_timer_perfect_threshold := 0.066 # if you press within this time after recovering, you get a bonus for perfect timing
@export var canoe_perfect_timing_reward := 1.66
@export var canoe_base_health_per_radius := 3.0 # ~canoe_size.x
@export var canoe_vehicle_power := 4.5
@export var canoe_linear_damp := 1.35
@export var canoe_angular_damp := 1.85


# how much of the impulse should be for pushing the canoe forward
# (the other part is for rotating us to the side)
@export var canoe_percentage_forward := 0.35 # 0.25 used to be the value for a long time

@export var canoe_destroyed_drops_canoe_element := true
@export var canoe_destroyed_drops_random_elements := 0

@export var swim_vehicle_power := 2.0

#
# SPECIAL EFFECTS / ELEMENTS
#
var speed_factor_bounds := Bounds.new(0.33, 1.85)
var vehicle_scale_factor_bounds := Bounds.new(0.5, 1.5)
var vehicle_mass_scale_bounds := Bounds.new(0.33, 1.85)

func get_map_base_size() -> float:
	return map_size_scalar * canoe_size.y
