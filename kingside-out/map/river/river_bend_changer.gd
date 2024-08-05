class_name RiverBendChanger extends Node

var dir:int = 1
var steps_in_current_bend := 0
var max_steps_in_current_bend := 0
var bounds_change:Bounds

func _init(bds_chg:Bounds):
	bounds_change = bds_chg
	if randf() <= 0.5: dir = -1
	reset()

func get_value() -> float:
	return dir

func pick_next_value() -> float:
	steps_in_current_bend += 1
	if steps_in_current_bend >= max_steps_in_current_bend:
		reset()
	return get_value()

func reset() -> void:
	reset_bend()
	flip_dir()

func flip_dir() -> void:
	dir *= -1

func reset_bend() -> void:
	steps_in_current_bend = 0
	max_steps_in_current_bend = bounds_change.rand_int()
