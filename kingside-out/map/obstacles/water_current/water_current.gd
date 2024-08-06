extends Area2D

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
	if radius_bounds.start > max_radius:
		self.queue_free()
		return
	
	var radius := randf_range(radius_bounds.start, max_radius)
	set_radius(radius)
	update_shader()

func set_radius(r:float) -> void:
	var shp = CircleShape2D.new()
	shp.radius = r
	col_shape.shape = shp
	sprite.set_scale(Vector2.ONE * 2 * r / 128.0)
	
	radius = r

func update_shader() -> void:
	sprite.material.set_shader_parameter("scroll_speed", Global.config.water_current_scroll_speed * strength)
	sprite.material.set_shader_parameter("scale", Global.config.water_current_shader_scale * sprite.scale.x)

func _physics_process(dt: float) -> void:
	var bodies = get_overlapping_bodies()
	var force := get_current_force()
	for body in bodies:
		if not (body is RigidBody2D): continue
		body.apply_central_force(force)

func get_current_strength() -> float:
	return Global.config.water_current_strength.interpolate(strength) * Global.config.canoe_mass

func get_current_force() -> Vector2:
	return get_current_dir() * get_current_strength()

func get_current_dir() -> Vector2:
	return Vector2.RIGHT.rotated( get_rotation() )
