class_name WaterCurrent extends Area2D

@export var radius := 1.0
@export var strength := 1.0 # this is a fraction of bounds defined in config
@onready var sprite : Sprite2D = $Sprite2D
@onready var col_shape : CollisionShape2D = $CollisionShape2D

func _ready():
	sprite.material = sprite.material.duplicate(true)
	
func from_spawn_point(sp:PossibleSpawnPoint) -> void:
	set_position(sp.pos)
	
	var rand_dir := 1 if randf() <= 0.5 else -1
	var rand_rotation := pow(randf(), 2) * PI # by squaring a number <1, we make low number more likely than high numbers
	var river_angle := sp.dir.angle()
	set_rotation(river_angle + rand_dir * rand_rotation)
	
	strength = randf() 
	
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
	sprite.material.set_shader_parameter("scroll_speed", Global.config.water_current_scroll_speed * (0.5 + 0.5*strength)) # if strength near 0, this would completely stop the shader, which looks weird, which is why we bump up this ratio
	sprite.material.set_shader_parameter("scale", Global.config.water_current_shader_scale * sprite.scale.x)

func _physics_process(_dt: float) -> void:
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if not (body is RigidBody2D): continue
		var force := get_current_force(body)
		body.apply_central_force(force)

func get_current_strength(body:RigidBody2D) -> float:
	var base_strength := Global.config.water_current_strength.interpolate(strength) * Global.config.canoe_vehicle_power
	base_strength *= body.mass
	if (body is VehicleSwim): 
		base_strength *= Global.config.swim_vehicle_water_current_factor
	return base_strength

func get_current_force(body:RigidBody2D) -> Vector2:
	return get_current_dir() * get_current_strength(body)

func get_current_dir() -> Vector2:
	return Vector2.RIGHT.rotated( get_rotation() )

func kill() -> void:
	queue_free()
