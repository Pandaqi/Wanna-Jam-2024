class_name Obstacle extends StaticBody2D

@onready var col_shape : CollisionShape2D = $CollisionShape2D
@onready var sprite : Sprite2D = $Sprite2D
@onready var health : ModuleHealth = $Health
@onready var water_ripples = $WaterRipples

signal size_changed(new_size:Vector2)

func _ready():
	health.depleted.connect(on_health_depleted)
	size_changed.connect(health.on_size_changed)
	
	var ripple_sprite = water_ripples.get_node("Sprite2D")
	ripple_sprite.material = ripple_sprite.material.duplicate(false)
	ripple_sprite.material.set_shader_parameter("speed", randf_range(0.3, 0.8));

func from_spawn_point(sp:PossibleSpawnPoint) -> void:
	set_position(sp.pos)
	
	var space_to_leave_empty := 2.0*Global.config.canoe_size.y
	var max_radius_before_left_blocked = sp.max_radius_left - space_to_leave_empty
	var max_radius_before_right_blocked = sp.max_radius_right - space_to_leave_empty
	
	var radius_bounds := Global.config.rocks_radius.clone().scale( Global.config.get_map_base_size() )
	var max_radius : float = min(max(max_radius_before_left_blocked, max_radius_before_right_blocked), radius_bounds.end)
	if radius_bounds.start > max_radius:
		self.queue_free()
		return
	
	var radius := randf_range(radius_bounds.start, max_radius)
	set_radius(radius)
	
	var base_health := radius * Global.config.rocks_health_per_radius
	health.set_base_health(base_health, true)

func set_radius(r:float) -> void:
	var shp = CircleShape2D.new()
	shp.radius = r
	col_shape.shape = shp
	
	var new_size := Vector2.ONE * 2 * r
	var final_scale := new_size / Global.config.sprite_base_size
	sprite.set_scale(final_scale)
	health.set_scale(final_scale)
	water_ripples.set_scale(final_scale)
	
	size_changed.emit(new_size)

func on_health_depleted() -> void:
	if not Global.config.rocks_can_be_destroyed: return
	kill()

func kill() -> void:
	if Global.config.rocks_spawn_random_elements:
		self.call_deferred("drop_element")
	self.queue_free()

func drop_element() -> void:
	var sp = PossibleSpawnPoint.new(global_position)
	GSignalBus.drop_element.emit(sp)
