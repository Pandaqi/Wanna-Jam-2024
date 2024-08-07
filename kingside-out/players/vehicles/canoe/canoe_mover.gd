class_name CanoeMover extends ModuleVehicleMover

@onready var paddle_left : Paddle = $PaddleLeft
@onready var paddle_right : Paddle = $PaddleRight

func on_driver_added(p:Player, side:Config.CanoeControlSide) -> void:
	if side == Config.CanoeControlSide.LEFT or side == Config.CanoeControlSide.BOTH:
		paddle_left.add_player(p)
	
	if side == Config.CanoeControlSide.RIGHT or side == Config.CanoeControlSide.BOTH:
		paddle_right.add_player(p)

func on_driver_removed(p:Player):
	paddle_left.remove_player(p)
	paddle_right.remove_player(p)
