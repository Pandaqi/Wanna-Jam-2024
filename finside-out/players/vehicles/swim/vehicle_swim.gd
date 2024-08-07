class_name VehicleSwim extends Vehicle

func activate() -> void:
	super.activate()
	mover.activate(physics)
