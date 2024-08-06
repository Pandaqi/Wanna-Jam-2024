class_name Element extends RigidBody2D

var data:ElementData

func set_type(ed:ElementData):
	data = ed
	# @TODO: actually visualize this and stuff

func needs_processing() -> bool:
	return not data.processed
