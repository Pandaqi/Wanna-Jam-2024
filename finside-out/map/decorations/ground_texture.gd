class_name GroundTexture extends Node2D

func _ready():
	var size_bounds := Global.config.ground_texture_size_bounds.clone().scale(Global.config.get_map_base_size())
	self_modulate.a = randf_range(0.5, 1.0)
	set_scale(size_bounds.rand_float() / 512.0 * Vector2.ONE)
