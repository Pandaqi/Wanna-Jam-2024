class_name Element extends RigidBody2D

var data:ElementData

@onready var col_shape : CollisionShape2D = $CollisionShape2D
@onready var sprite : Sprite2D = $Sprite2D

func _ready():
	var size_bounds := Global.config.element_size_bounds.clone().scale(Global.config.get_map_base_size())
	var rand_size := size_bounds.rand_float()
	var new_scale := rand_size / Global.config.sprite_base_size * Vector2.ONE
	sprite.set_scale(new_scale)
	
	var shp = CircleShape2D.new()
	shp.radius = 0.5*rand_size
	col_shape.shape = shp

func set_type(ed:ElementData):
	data = ed
	sprite.set_frame(data.frame)

func needs_processing() -> bool:
	return not data.processed

func kill() -> void:
	queue_free()
