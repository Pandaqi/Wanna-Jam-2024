class_name ModuleElementGrabber extends Node

signal available_for_processing(ed:ElementData)
signal exclusion_ended(node:Element)

@onready var entity : Player = get_parent()

var excluded_bodies : Array[Element] = []

func activate(v:ModuleVehicleManager, ed:ModuleElementDropper):
	v.connected.connect(on_vehicle_connected)
	v.released.connect(on_vehicle_released)
	ed.element_dropped.connect(on_element_dropped)

func on_vehicle_connected(v:Vehicle) -> void:
	v.feeler.body_entered.connect(on_body_entered)

func on_vehicle_released(v:Vehicle) -> void:
	v.feeler.body_entered.disconnect(on_body_entered)

func on_element_dropped(e:Element) -> void:
	exclude_body(e)

func exclude_body(b:Element) -> void:
	excluded_bodies.append(b)
	await get_tree().create_timer(0.66).timeout
	if not is_instance_valid(b) or not excluded_bodies.has(b): return
	excluded_bodies.erase(b)
	exclusion_ended.emit(b)

func is_excluded(b:Element) -> bool:
	return excluded_bodies.has(b)

func on_body_entered(body:Node2D) -> void:
	if not (body is Element): return
	if is_excluded(body): return
	
	body.kill()
	if body.needs_processing():
		available_for_processing.emit(body.data)
		return
	
	trigger_element(body.data)

func trigger_element(ed:ElementData) -> void:
	ed.execute(self)
