class_name Piranhas extends Node2D

# @TODO: all the functionality for following track, chasing player, killing them
func activate() -> void:
	GSignalBus.piranha_change.connect(on_piranha_change)

# @TODO: just make them pause for the amount of time specified? Or permanently change their speed by this value?
func on_piranha_change(dp:float) -> void:
	pass
