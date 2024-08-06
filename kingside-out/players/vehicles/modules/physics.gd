class_name ModulePhysics extends Node2D

@onready var entity : Vehicle = get_parent()
@onready var col_shape : CollisionPolygon2D = get_parent().get_node("CollisionPolygon2D")
var prev_vel : Vector2
var scale_factor : float = 1.0

signal size_changed(new_size:Vector2)

func activate() -> void:
	entity.mass = Global.config.canoe_mass
	entity.body_entered.connect(on_body_entered)
	change_scale(1.0)

func _physics_process(_dt:float) -> void:
	prev_vel = entity.get_linear_velocity()

func on_body_entered(body:Node2D) -> void:
	if not ("health" in body): return
	
	var health_mod : ModuleHealth = body.health
	var hit_vel : float = max(prev_vel.length(), entity.get_linear_velocity().length())
	var damage = hit_vel * Global.config.rocks_damage_per_velocity
	health_mod.update_health(-damage)

func change_scale(ds:float) -> void:
	scale_factor *= ds
	refresh_body()
	size_changed.emit(get_size())

func refresh_body() -> void:
	var bevel := Global.config.canoe_body_bevel * scale_factor
	var canoe_size := Global.config.canoe_size * scale_factor
	var half_size := 0.5 * canoe_size
	
	var poly : PackedVector2Array = [
		Vector2(-half_size.x, -bevel),
		Vector2(-bevel, -half_size.y),
		Vector2(bevel, -half_size.y),
		Vector2(half_size.x, -bevel),
		Vector2(half_size.x, bevel),
		Vector2(bevel, half_size.y),
		Vector2(-bevel, half_size.y)
	]
	
	col_shape.polygon = poly

func get_size() -> Vector2:
	return Global.config.canoe_size * scale_factor
