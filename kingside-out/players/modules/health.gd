class_name ModuleHealth extends Node2D

var base_health := 100.0
var health := 0.0

signal depleted()

func set_base_health(h:float, fill := false) -> void:
	base_health = h
	if fill: refill()

func drain() -> void:
	update_health(-health)

func refill() -> void:
	health = 0
	update_health(base_health)

func get_health_ratio() -> float:
	return health / base_health

func update_health(h:float) -> void:
	health = clamp(health + h, 0.0, base_health)
	
	if health <= 0:
		depleted.emit()
