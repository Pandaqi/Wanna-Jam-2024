extends Node2D

func _ready():
	var scale_bounds := Global.config.decoration_scale_bounds.clone().scale(Global.config.get_map_base_size()).scale_bounds(Global.config.decoration_step_bounds)
	set_scale(scale_bounds.rand_float() / Global.config.sprite_base_size * Vector2.ONE)
