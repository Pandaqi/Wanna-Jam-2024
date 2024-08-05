class_name Bounds

var min := 0.0
var max := 1.0

func _init(a:float, b:float):
	min = a
	max = b

func clamp_value(val:float) -> float:
	return clamp(val, min, max)

func rand_float() -> float:
	return randf_range(min, max)

func rand_int() -> int:
	return floor(randf_range(min,max+0.999))
