class_name ModuleEffectsTracker extends Node

var time_bonus := 0.0

func add_time(dt:float) -> void:
	time_bonus += dt

func get_total_time_ms() -> float:
	return time_bonus * 1000.0
