extends Node2D

@onready var area : Area2D = $Area2D
@onready var col_shape : CollisionShape2D = $Area2D/CollisionShape2D
@onready var particles : CPUParticles2D = $CPUParticles2D
@onready var audio_player := $AudioStreamPlayer2D

func _ready() -> void:
	play_effects()

func play_effects() -> void:
	var radius := Global.config.explosion_radius * Global.config.get_map_base_size()
	
	var shp = CircleShape2D.new()
	shp.radius = radius
	col_shape.shape = shp
	
	particles.emission_sphere_radius = radius
	particles.set_emitting(true)
	
	audio_player.pitch_scale = randf_range(0.9, 1.1)
	audio_player.play()
	
	await get_tree().physics_frame
	
	destroy_overlapping_bodies()
	
	await audio_player.finished

	self.queue_free()

func destroy_overlapping_bodies() -> void:
	var explosion_force := Global.config.explosion_force * Global.config.get_map_base_size() * Global.config.canoe_mass
	
	for body in area.get_overlapping_bodies():
		if (body is Vehicle):
			var blow_away_force := (body.global_position - global_position).normalized() * explosion_force
			body.apply_central_impulse(blow_away_force)
		
		if (body is Obstacle or body is Element):
			body.kill()
	
	for area_overlapped in area.get_overlapping_areas():
		if not (area_overlapped is WaterCurrent): continue
		area_overlapped.kill()
