class_name ModulePhysics extends Node2D

@onready var entity : Vehicle = get_parent()
@onready var col_shape : CollisionPolygon2D = get_parent().get_node("CollisionPolygon2D")

var prev_vel : Vector2
var scale_factor := 1.0
var mass_scale := 1.0
var ghost := false

@export var base_scale_factor := Vector2(1.0, 1.0)
@export var base_mass_factor := 1.0

@onready var timer_ghost : Timer = $TimerGhost

@onready var audio_player := $AudioStreamPlayer2D

signal size_changed(new_size:Vector2)
signal ghost_changed(val:bool)

func activate() -> void:
	timer_ghost.wait_time = Global.config.ghost_effect_duration
	timer_ghost.timeout.connect(on_timer_ghost_timeout)
	
	entity.body_entered.connect(on_body_entered)
	change_mass(1.0)
	change_scale(1.0)

func _physics_process(_dt:float) -> void:
	prev_vel = entity.get_linear_velocity()

func on_body_entered(body:Node2D) -> void:
	if ghost: return
	if not ("health" in body): return
	
	var health_mod : ModuleHealth = body.health
	var hit_vel : float = max(prev_vel.length(), entity.get_linear_velocity().length())
	var damage = hit_vel * Global.config.rocks_damage_per_velocity
	health_mod.register_attacker(body)
	health_mod.update_health(-damage)
	
	var damage_factor := 1.0
	if (body is Vehicle) and (entity is Vehicle):
		damage_factor = Global.config.vehicle_to_vehicle_hit_damage_factor
	
	if "health" in entity:
		var self_health_mod = entity.health
		self_health_mod.update_health(-damage * damage_factor)
	
	audio_player.pitch_scale = randf_range(0.9, 1.1)
	audio_player.play()

func change_scale(ds:float) -> void:
	scale_factor = Global.config.vehicle_scale_factor_bounds.clamp_value(scale_factor * ds)
	call_deferred("refresh_body")
	size_changed.emit(get_size())

func change_mass(dm:float) -> void:
	mass_scale = Global.config.vehicle_mass_scale_bounds.clamp_value(mass_scale * dm)
	call_deferred("refresh_mass")

func refresh_mass() -> void:
	var new_mass := Global.config.canoe_mass * mass_scale * base_mass_factor
	entity.mass = new_mass

func set_ghost(val:bool, permanent := false) -> void:
	ghost = val
	entity.set_collision_layer_value(2, not ghost)
	entity.set_collision_layer_value(4, not ghost)
	entity.set_collision_mask_value(2, not ghost)
	if val and (not permanent):
		timer_ghost.start()
	ghost_changed.emit(val)

func on_timer_ghost_timeout() -> void:
	set_ghost(false)

func refresh_body() -> void:
	var bevel := Global.config.canoe_body_bevel * scale_factor
	var canoe_size := get_size()
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
	return Global.config.canoe_size * scale_factor * base_scale_factor
