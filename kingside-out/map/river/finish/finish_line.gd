extends Node2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var col_shape : CollisionShape2D = $Area2D/CollisionShape2D
@onready var area : Area2D = $Area2D

var finish_vec : Vector2 # which side is determined to be "after the finish"

func update(finish_line:Line) -> void:
	var center = finish_line.get_center()
	var size = finish_line.get_length()
	
	# position and rotate us as needed to fit the track
	set_position(center)
	set_rotation(finish_line.angle())
	
	# @NOTE: the start position is saved lEFT->RIGHT,
	# so the finish has its points RIGHT->LEFT
	# which is why DOWN is actually the right finish vec
	finish_vec = Vector2.DOWN.rotated(get_rotation())
	
	# update our shader to get blocky pattern across the whole thing (with consistent size)
	var finish_width := Global.config.finish_width * Global.config.canoe_size.x
	var sprite_base_scale := 128.0 * Vector2.ONE
	var desired_size := Vector2(size, finish_width)
	sprite.set_scale(desired_size / sprite_base_scale)
	sprite.material.set_shader_parameter("sprite_size", desired_size)
	
	# update our collision shape to match
	var new_shp = RectangleShape2D.new()
	new_shp.size = desired_size
	col_shape.shape = new_shp

func _physics_process(_dt:float) -> void:
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if not body.is_in_group("Vehicles"): continue
		if body.is_finished(): continue
		var vec_to_body = (body.global_position - global_position).normalized()
		var dot_prod = vec_to_body.dot(finish_vec)
		if dot_prod < 0: continue
		body.finish()
		
