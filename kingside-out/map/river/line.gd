class_name Line

var start:Vector2
var end:Vector2
var vec:Vector2

func _init(a:Vector2, b:Vector2):
	start = a
	end = b
	vec = end - start
