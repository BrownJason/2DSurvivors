extends Node

const MAX_RANGE = 150

@export var sword_ability: PackedScene
@onready var damage_calculations = $DamageCalculations

var base_damage = 5
var base_critical_chance = 0.05 # 5 % crit change
var base_critical_damage = 0.5  # 50% crit damage, 1.5x base damage
var additional_damage_percent = 1
var base_wait_time

var damage_info = {
	"base_damage": base_damage,
	"base_critical_chance": base_critical_chance,
	"base_critical_damage": base_critical_damage
}

func _ready():
	damage_info = damage_calculations.get_damage_increase_calculations()
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(_on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(func(a: Node2D, b: Node2D): 
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		
		return a_distance < b_distance
	)
	
	var sword_instance = sword_ability.instantiate() as SwordAbility
	var foregound_layer = get_tree().get_first_node_in_group("foreground_layer")
	foregound_layer.add_child(sword_instance)
	var crit_hit = randf_range(0, 1)
	var initial_damage = damage_info["base_damage"] * additional_damage_percent
	if crit_hit <= damage_info["base_critical_chance"]:
		sword_instance.hit_box_component.damage = (initial_damage + (initial_damage * damage_info["base_critical_damage"])) 
		sword_instance.hit_box_component.is_crit = true 
	else:
		sword_instance.hit_box_component.damage = initial_damage
		sword_instance.hit_box_component.is_crit = false 
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "sword_rate":
		var percent_reduction = current_upgrades["sword_rate"]["quantity"] * 0.1
		$Timer.wait_time = base_wait_time * (1 - percent_reduction)
		$Timer.start()
	elif upgrade.id == "sword_damage":
		additional_damage_percent = 1 + (current_upgrades["sword_damage"]["quantity"] * 0.15)
