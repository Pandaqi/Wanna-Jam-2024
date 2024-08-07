class_name Line

var start:Vector2
var end:Vector2
var vec:Vector2

func _init(a:Vector2, b:Vector2):
	start = a
	end = b
	vec = end - start

func interpolate(frac:float) -> Vector2:
	return start + frac * vec

func get_length() -> float:
	return vec.length()

func angle() -> float:
	return vec.angle()

func get_center() -> Vector2:
	return 0.5 * (start + end)

func get_ortho() -> Vector2:
	return vec.rotated(0.5*PI)

func as_array() -> PackedVector2Array:
	return [start, end]

func rand_point() -> Vector2:
	return start + randf() * vec
