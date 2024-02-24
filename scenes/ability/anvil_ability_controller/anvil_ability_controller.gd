extends Node

const BASE_RANGE = 100

@export var anvil_ability_scene: PackedScene
@onready var damage_calculations = $DamageCalculations

var base_damage = 15
var base_critical_chance = 0.05 # 5 % crit change
var base_critical_damage = 0.5  # 50% crit damage, 1.5x base damage
var additional_anvil = 0

var damage_info = {
	"base_damage": base_damage,
	"base_critical_chance": base_critical_chance,
	"base_critical_damage": base_critical_damage
}

func _ready():
	damage_info = damage_calculations.get_damage_increase_calculations()
	$Timer.timeout.connect(_on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	
	var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var additional_rotation_degress = 360.0 / (additional_anvil + 1)
	var anvil_distance = randf_range(0, BASE_RANGE)
	for i in additional_anvil + 1:	
		var adjusted_direction = direction.rotated(deg_to_rad(i * additional_rotation_degress))
		var spawn_position = player.global_position + adjusted_direction * anvil_distance
		
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1 << 0)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		if not result.is_empty():
			spawn_position = result["position"]
			
		var anvil_ability = anvil_ability_scene.instantiate()
		get_tree().get_first_node_in_group("foreground_layer").add_child(anvil_ability)
		anvil_ability.global_position = spawn_position
		var calculated_damage = damage_calculations.calculate_damage(anvil_ability, 1)
		anvil_ability.hit_box_component.damage = calculated_damage["damage"]
		anvil_ability.hit_box_component.is_crit = calculated_damage["is_crit"]


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "anvil_count":
		additional_anvil = current_upgrades["anvil_count"]["quantity"]
