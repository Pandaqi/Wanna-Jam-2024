class_name WaterCurrent extends Area2D

@export var radius := 1.0
@export var strength := 1.0 # this is a fraction of bounds defined in config
@onready var sprite : Sprite2D = $Sprite2D
@onready var col_shape : CollisionShape2D = $CollisionShape2D
@onready var debug_label := $DebugLabel

var time_spent_in_current := 0.0
var auto_rotate_factor := 0.0
var auto_rotate_dir := 1
var auto_fade_factor := 0.0
var auto_fade_dir := 1
var cur_fade_val := 1.0

func _ready() -> void:
	sprite.material = sprite.material.duplicate(false)
	debug_label.set_visible(OS.is_debug_build() and Global.config.debug_show_labels)
	
func from_spawn_point(sp:PossibleSpawnPoint) -> void:
	set_position(sp.pos)
	
	var rand_dir := 1 if randf() <= 0.5 else -1
	var rand_rotation := pow(randf(), 2) * PI # by squaring a number <1, we make low number more likely than high numbers
	var river_angle := sp.dir.angle()
	set_rotation(river_angle + rand_dir * rand_rotation)
	
	auto_rotate_factor = Global.config.water_current_auto_rotate_bounds.rand_float()
	auto_rotate_dir = 1 if randf() <= 0.5 else -1
	auto_fade_factor = Global.config.water_current_auto_fade_bounds.rand_float()
	
	strength = Global.config.water_current_strength_bounds.rand_float()
	
	var backwards_rot_diff : float = clamp((rand_rotation - 0.5*PI) / 0.5*PI, 0.0, 1.0)
	var backwards_ratio : float = lerp(1.0, Global.config.water_current_backwards_strength_modifier, backwards_rot_diff)
	strength *= backwards_ratio

	var radius_bounds := Global.config.water_current_radius.clone().scale(Global.config.get_map_base_size())
	var max_radius := sp.get_max_radius()
	
	if sp.prev_point:
		var max_dist_to_prev_point := (sp.pos - sp.prev_point.pos).length() # to prevent any overlaps in the first place
		max_radius = min(max_radius, max_dist_to_prev_point)
	
	if radius_bounds.start > max_radius:
		self.queue_free()
		return
	
	var new_radius := randf_range(radius_bounds.start, max_radius)
	set_radius(new_radius)
	update_shader()

func set_radius(r:float) -> void:
	var shp = CircleShape2D.new()
	shp.radius = r
	col_shape.shape = shp
	sprite.set_scale(Vector2.ONE * 2 * r / 128.0)
	
	radius = r

func update_shader() -> void:
	var strength_factor := strength * get_time_factor()
	
	# @NOTE: if strength near 0, this would completely stop the shader, which looks weird, which is why we bump up this ratio
	var new_scroll_speed := Global.config.water_current_scroll_speed * (0.5 + 0.5*strength_factor)
	
	var strength_rounded : float = round(strength_factor * 100) / 100.0
	var scroll_speed_rounded : float = round(new_scroll_speed * 100) / 100.0
	debug_label.set_text(str(strength_rounded) + "/" + str(scroll_speed_rounded))
	
	sprite.material.set_shader_parameter("scale", Global.config.water_current_shader_scale * sprite.scale.x)
	sprite.material.set_shader_parameter("scroll_speed", new_scroll_speed) 

func _physics_process(dt: float) -> void:
	auto_change(dt)
	push_bodies(dt)

func auto_change(dt:float) -> void:
	if not is_zero_approx(auto_rotate_factor):
		set_rotation( get_rotation() + auto_rotate_factor * auto_rotate_dir * dt )
	
	if not is_zero_approx(auto_fade_factor):
		cur_fade_val += auto_fade_dir * auto_fade_factor * dt
		if cur_fade_val <= 0:
			auto_fade_dir = 1
			cur_fade_val = 0
		
		if cur_fade_val >= 1.0:
			auto_fade_dir = -1
			cur_fade_val = 1

func push_bodies(dt:float) -> void:
	var bodies = get_overlapping_bodies()
	var something_changed := false
	for body in bodies:
		if not (body is Vehicle): continue
		var force := get_current_force(body)
		body.apply_central_force(force)
		something_changed = true
	
	# @NOTE: Funnily enough, we only update the shader when nobody is moving through it and thus changing it
	# Because if we change it then, we run into phase issues that make it APPEAR as if the shader is running backward or changing in some other way
	if not something_changed: 
		update_shader()
		return
	time_spent_in_current += dt

func get_time_factor() -> float:
	var time_ratio : float = clamp( time_spent_in_current / Global.config.water_current_time_spent_before_still, 0.0, 1.0)
	var time_factor := Global.config.water_current_time_spent_bounds.interpolate(time_ratio)
	return time_factor * cur_fade_val

func get_current_strength(body:RigidBody2D) -> float:
	var base_strength := Global.config.water_current_strength.interpolate(strength) * Global.config.canoe_vehicle_power
	base_strength *= body.mass
	
	if (body is VehicleSwim): 
		base_strength *= Global.config.swim_vehicle_water_current_factor
	
	base_strength *= get_time_factor()
	return base_strength

func get_current_force(body:RigidBody2D) -> Vector2:
	return get_current_dir() * get_current_strength(body)

func get_current_dir() -> Vector2:
	return Vector2.RIGHT.rotated( get_rotation() )

func kill() -> void:
	queue_free()
