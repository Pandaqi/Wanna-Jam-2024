class_name ModuleTutorial extends Node2D

@onready var input_hint : InputHint = $InputHint
@onready var entity : Player = get_parent()

func activate(player_num:int):
	set_scale(Global.config.canoe_size.x / 512.0 * Vector2.ONE)
	
	input_hint.set_data(player_num)
	var tw = get_tree().create_tween()
	tw.tween_property(self, "modulate:a", 0.0, 10.0)
	tw.tween_callback(on_tween_done)

func _process(_dt:float) -> void:
	self.set_position( entity.vehicle_manager.get_vehicle_position() + Vector2.UP * 0.5 * 512.0 * scale.x )

func on_tween_done():
	queue_free()
