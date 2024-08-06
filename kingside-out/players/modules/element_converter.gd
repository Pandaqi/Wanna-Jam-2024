class_name ModuleElementConverter extends Node2D

@onready var timer : Timer = $Timer

signal available_for_drop(ed:ElementData)

func activate(eg:ModuleElementGrabber) -> void:
	eg.available_for_processing.connect(process_element)

func process_element(ed:ElementData):
	timer.wait_time = Global.config.conversion_duration_bounds.rand_float()
	timer.start()
	await timer.timeout
	on_process_complete(ed)
	# @TODO: display some animation, actually change the type to the right one

func on_process_complete(ed:ElementData):
	available_for_drop.emit(ed)
