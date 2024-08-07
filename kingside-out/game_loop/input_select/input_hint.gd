class_name InputHint extends Node2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var labels : Dictionary = {
	"right": $InputRight/Label,
	"left": $InputLeft/Label,
}

func set_data(player_num:int) -> void:
	var is_keyboard := GInput.is_keyboard_player(player_num)
	
	var frame := 6
	if is_keyboard: frame = 5
	sprite.set_frame(frame)
	
	for key in labels:
		labels[key].set_visible(is_keyboard)
	
	if not is_keyboard: return
	
	var keys_raw = GInput.get_keyboard_keys_for_player(player_num)
	for key in keys_raw:
		if not (key in labels): continue
		
		var key_conv := OS.get_keycode_string(keys_raw[key])
		var label : Label = labels[key]
		if ["Left", "Right", "Up", "Down"].has(key_conv):
			key_conv = ">"
		else:
			label.get_parent().set_rotation(0)
		
		label.set_text(key_conv)
