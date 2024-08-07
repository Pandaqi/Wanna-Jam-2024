extends Node2D

@onready var area : Area2D = $Area2D

func _ready() -> void:
	await get_tree().process_frame # otherwise the area hasn't checked any overlaps yet
	destroy_overlapping_bodies()

# @TODO: also blow away other boats?
# @TODO: some particles and sfx of course
func destroy_overlapping_bodies() -> void:
	for body in area.get_overlapping_bodies():
		if not (body is Obstacle or body is Element): continue
		body.kill()
	
	for area_overlapped in area.get_overlapping_areas():
		if not (area_overlapped is WaterCurrent): continue
		area_overlapped.kill()
	
	self.queue_free()
