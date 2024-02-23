extends Node

@export var axe_ability_scene: PackedScene

@onready var timer = $Timer

var base_damage = 10
var base_critical_chance = 0.05 # 5 % crit change
var base_critical_damage = 0.5  # 50% crit damage, 1.5x base damage
var additional_damage_percent = 1

func _ready():
	var base_damage_increase = MetaProgression.get_upgrade_count("damage_increase")
	if base_damage_increase > 0:
		base_damage = (base_damage + base_damage * (base_damage_increase * 0.1))
	var base_critical_chance_increase = MetaProgression.get_upgrade_count("critical_chance")
	if base_critical_chance_increase > 0:
		base_critical_chance = base_critical_chance + (base_critical_chance_increase * 0.05)
	var base_critical_damage_increase = MetaProgression.get_upgrade_count("critical_damage")
	if base_critical_damage_increase > 0:
		base_critical_damage = base_critical_damage + (base_critical_damage_increase * 0.10)
	
		
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	var axe_instance = axe_ability_scene.instantiate()
	foreground.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	var crit_hit = randf_range(0, 1)
	if crit_hit <= base_critical_chance:
		var initial_damage = base_damage * additional_damage_percent
		axe_instance.hit_box_component.damage = (initial_damage + (initial_damage * base_critical_damage)) 
		axe_instance.hit_box_component.is_crit = true 
	else:
		axe_instance.hit_box_component.damage = base_damage * additional_damage_percent
		axe_instance.hit_box_component.is_crit = false 


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "axe_damage":
		additional_damage_percent = 1 + (current_upgrades["axe_damage"]["quantity"] * 0.10)
