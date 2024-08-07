class_name PlayerSelect extends Node2D

@onready var bg : Sprite2D = $BG
@onready var icon : Sprite2D = $PlayerIcon
@onready var label_number : Label = $LabelPlayerNumber
@onready var label_instruction : Label = $LabelInstruction
@onready var input_hint : InputHint = $InputHint
@onready var anim_player : AnimationPlayer = $AnimationPlayer

var instruction_inactive := "Press ENTER (keyboard) or ANY (gamepad) to login a new player."
var instruction_active := "Press your movement keys to ready up!"
var instruction_ready := "READY!"

var player_num : int
var active := true
var is_ready := false

signal readied_up()

func set_data(i:int) -> void:
	player_num = i
	
	icon.set_frame(4 + i)
	label_number.set_text("Player " + str(i+1))
	deactivate()

func deactivate(next_node_up = false) -> void:
	ready_down()
	
	active = false
	bg.modulate.a = 0.5
	icon.modulate.a = 0.5
	label_instruction.set_text(instruction_inactive)
	label_instruction.set_visible(next_node_up)
	input_hint.set_visible(false)

func activate() -> void:
	active = true
	bg.modulate.a = 1.0
	icon.modulate.a = 1.0
	label_instruction.set_text(instruction_active)
	label_instruction.set_visible(true)
	input_hint.set_visible(true)
	input_hint.set_data(player_num)
	
func ready_down():
	if not is_ready: return
	is_ready = false
	label_instruction.set_text(instruction_active)
	label_instruction.set_visible(true)
	anim_player.stop()

func ready_up():
	is_ready = true
	label_instruction.set_text(instruction_ready)
	label_instruction.set_visible(true)
	readied_up.emit()
	anim_player.play("player_ready_wiggle")

func _input(_ev):
	if is_ready: return
	if GInput.get_move_vec(player_num).length() > 0.5:
		ready_up()
