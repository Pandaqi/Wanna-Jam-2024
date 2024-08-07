class_name ModuleInput extends Node

@export var player_num : int = -1
var prev_move_vec := Vector2.ZERO
var epsilon := 0.1

signal movement_vector_update(vec, dt)

func activate(num:int):
	player_num = num

func is_connected_to_player() -> bool:
	return player_num >= 0 and player_num < GInput.get_player_count()

func _physics_process(_dt:float) -> void:
	if not is_connected_to_player(): return
	update_movement_vector()

func update_movement_vector() -> void:
	var move_vec := GInput.get_move_vec(player_num, false)
	prev_move_vec = move_vec
	movement_vector_update.emit(move_vec)

func is_left() -> bool:
	return prev_move_vec.x < -epsilon

func is_right() -> bool:
	return prev_move_vec.x > epsilon
