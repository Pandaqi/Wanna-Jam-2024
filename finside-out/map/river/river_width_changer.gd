class_name RiverWidthChanger

var change_dir:int = 1
var value:float = 0
var bounds:Bounds
var bounds_change:Bounds

func _init(start_width:float, bds:Bounds, bds_chg:Bounds):
	bounds = bds
	bounds_change = bds_chg
	if randf() <= 0.5: flip_dir()
	change_value(start_width)

func get_value() -> float:
	return value

func change_value(dv:float) -> float:
	value = bounds.clamp_value(value + dv)
	if bounds.is_at_extreme(value):
		flip_dir()
	return value

func scale_value(ds:float) -> float:
	return change_value(ds * value - value)

func pick_next_value() -> float:
	change_value(change_dir * bounds_change.rand_float())
	return value

func flip_dir() -> void:
	change_dir *= -1
