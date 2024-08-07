class_name ModuleElementConverter extends Node2D

@export var spawner : MapSpawnerRiver
@onready var timer : Timer = $Timer

var river_tracker : ModuleRiverTracker

signal available_for_drop(ed:ElementData)

func activate(eg:ModuleElementGrabber, rt:ModuleRiverTracker) -> void:
	river_tracker = rt
	eg.available_for_processing.connect(process_element)

func process_element(ed:ElementData):
	timer.wait_time = Global.config.conversion_duration_bounds.rand_float()
	timer.start()
	
	await timer.timeout
	
	var new_data = spawner.available_elements.pick_random()
	if Global.config.area_determines_drop_type:
		new_data = river_tracker.get_current_area().type
	on_process_complete(new_data)
	
	# @TODO: display some animation while busy

func on_process_complete(ed:ElementData):
	available_for_drop.emit(ed)
