class_name VehicleCanoe extends Vehicle

@onready var health : ModuleHealth = $Health
@export var swim_vehicle : PackedScene

@export var canoe_element : ElementData

func _ready() -> void:
	var base_health := Global.config.canoe_base_health_per_radius * Global.config.canoe_size.x
	health.set_base_health(base_health, true)
	health.depleted.connect(on_health_depleted)
	self.killed.connect(health.on_killed)
	physics.size_changed.connect(health.on_size_changed)
	
	# @TODO: move this to physics? set this a bit more cleanly?
	linear_damp = Global.config.canoe_linear_damp
	angular_damp = Global.config.canoe_angular_damp

func on_health_depleted() -> void:
	kill()
	
	for p in connected_players:
		call_deferred("send_player_swimming", p)

# @TODO: should the CANOE really be the one instantiating the swim vehicle!?
func send_player_swimming(p:Player) -> void:
	if not connected_players.has(p): return
	
	var v : VehicleSwim = swim_vehicle.instantiate()
	v.set_position(global_position)
	GSignalBus.place_on_map.emit(v, "players")
	v.activate()
	p.vehicle_manager.connect_to(v)
	
	if Global.config.canoe_destroyed_drops_canoe_element:
		p.element_dropper.drop(canoe_element, true)
	
	if Global.config.canoe_destroyed_drops_random_elements >= 1:
		var num := Global.config.canoe_destroyed_drops_random_elements
		for i in range(num):
			p.element_dropper.drop_random()
