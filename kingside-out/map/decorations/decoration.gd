extends Node2D

# @TODO: properly modify based on map size
func _ready():
	set_scale(randf_range(0.5, 0.9) * Vector2.ONE)
