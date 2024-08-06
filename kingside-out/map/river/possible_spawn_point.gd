class_name PossibleSpawnPoint

var pos:Vector2
var max_radius_left:float # distance to left bank
var max_radius_right:float # distance to right bank
var dir:Vector2 # the direction of the track at this point
var prev_point:PossibleSpawnPoint
var force:Vector2 # immediate impulse upon spawn, if set
var type_elem:ElementData

func _init(p:Vector2, d:= Vector2.ZERO, pp:PossibleSpawnPoint = null, mrl := 0.0, mrr := 0.0):
	pos = p
	dir = d
	prev_point = pp
	max_radius_left = mrl
	max_radius_right = mrr
	force = Vector2.ZERO

func get_max_radius() -> float:
	return min(max_radius_left, max_radius_right)
