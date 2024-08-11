extends CanvasLayer

var cur_index := -1
var max_index := 2

var active := false

@onready var container : Node2D = $Container
@onready var sprite := $Container/Sprite2D
@onready var anim_player := $Container/AnimationPlayer

const SOLO_FRAME = 1
const MULTI_FRAME = 0

signal done()

func _ready() -> void:
	get_tree().get_root().size_changed.connect(on_resize)
	on_resize()
	set_visible(false)

func on_resize() -> void:
	var vp_size := container.get_viewport_rect().size
	container.set_position(0.5 * vp_size)
	
	var match_scale = min(vp_size.x / 1024.0, vp_size.y / 576)
	if match_scale > 1.0: return
	container.set_scale(Vector2.ONE * match_scale)

func activate() -> void:
	load_next()

func load_next() -> void:
	cur_index += 1
	
	set_visible(true)
	get_tree().paused = true
	active = true

	if cur_index >= max_index:
		dismiss()
		return
	
	if cur_index == 0:
		var frame := SOLO_FRAME if GInput.get_player_count() <= 1 else MULTI_FRAME
		sprite.set_frame(frame)
	
	if cur_index == 1:
		sprite.set_frame(2)
	
	anim_player.play("appear")

func dismiss() -> void:
	active = false
	anim_player.play_backwards("appear")
	await anim_player.animation_finished
	
	done.emit()
	get_tree().paused = false
	self.queue_free()
	
func _input(ev:InputEvent) -> void:
	if not active: return
	if ev.is_action_released("game_over_restart"):
		load_next()
