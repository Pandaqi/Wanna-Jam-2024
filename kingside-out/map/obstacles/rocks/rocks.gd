extends StaticBody2D

@onready var col_shape : CollisionShape2D = $CollisionShape2D
@onready var sprite : Sprite2D = $Sprite2D

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

func set_radius(r:float) -> void:
	var shp = CircleShape2D.new()
	shp.radius = r
	col_shape.shape = shp
	sprite.set_scale(Vector2.ONE * 2 * r / 128.0)
