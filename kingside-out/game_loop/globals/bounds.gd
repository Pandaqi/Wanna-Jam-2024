class_name Bounds

var start := 0.0
var end := 1.0

var epsilon := 0.00003

func _init(a:float, b:float):
	start = a
	end = b

func clone() -> Bounds:
	return Bounds.new(start, end)

func clamp_value(val:float) -> float:
	return clamp(val, start, end)

func rand_float() -> float:
	return randf_range(start, end)

func rand_int() -> int:
	return floor(randf_range(start, end+0.999))

func is_at_extreme(val:float) -> bool:
	return val <= start or val >= end

func scale(s:float) -> Bounds:
	start *= s
	end *= s
	return self

func scale_bounds(b:Bounds) -> Bounds:
	start *= b.start
	end *= b.end
	return self

func interpolate(factor:float) -> float:
	return lerp(start, end, factor)
