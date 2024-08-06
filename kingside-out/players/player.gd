class_name Player extends Node2D

var player_num := -1
var finished := false

@onready var input : ModuleInput = $Input
@onready var vehicle_manager : ModuleVehicleManager = $VehicleManager
@onready var element_grabber : ModuleElementGrabber = $ElementGrabber
@onready var element_converter : ModuleElementConverter = $ElementConverter
@onready var element_dropper : ModuleElementDropper = $ElementDropper
@onready var river_tracker : ModuleRiverTracker = $RiverTracker

func activate(num:int, element_spawner:ElementSpawner) -> void:
	player_num = num
	input.activate(num)
	
	vehicle_manager.finished.connect(on_finished)
	element_grabber.activate(vehicle_manager, element_dropper)
	element_converter.activate(element_grabber, river_tracker)
	element_dropper.activate(vehicle_manager, element_converter, element_spawner)
	river_tracker.activate(vehicle_manager)

func on_finished() -> void:
	finished = true
	Global.player_finished.emit(player_num)
	print("PLAYER " + str(player_num) + "HAS FINISHED!")
