extends Node

@export var base_damage: float
@export var base_critical_chance: float
@export var base_critical_damage: float

var damage_info = {
	"base_damage": base_damage,
	"base_critical_chance": base_critical_chance,
	"base_critical_damage": base_critical_damage
}

var damage_increase: int = 0
var critical_chance_increase: int = 0
var critical_damage_increase: int = 0

func _ready():
	damage_increase = MetaProgression.get_upgrade_count("damage_increase")
	critical_chance_increase = MetaProgression.get_upgrade_count("critical_chance")
	critical_damage_increase = MetaProgression.get_upgrade_count("critical_damage")

func get_damage_increase_calculations() -> Dictionary:
	damage_info["base_damage"] = (base_damage + (base_damage * damage_increase * 0.1))
	damage_info["base_critical_chance"] = base_critical_chance + (critical_chance_increase * 0.05)
	damage_info["base_critical_damage"] = base_critical_damage + (critical_damage_increase * 0.10)
		
	return damage_info

func calculate_damage(instance: Node2D, additional_damage_percent: float) -> Dictionary:
	var crit_hit = randf_range(0, 1)
	var initial_damage = damage_info["base_damage"] * additional_damage_percent
	var calculated_damage = 0
	var values = {
		"damage": calculated_damage,
		"is_crit": false
	}
	
	if crit_hit <= damage_info["base_critical_chance"]:
		values["damage"] = (initial_damage + (initial_damage * damage_info["base_critical_damage"])) 
		values["is_crit"] = true 
	else:
		values["damage"] = initial_damage
		values["is_crit"] = false 
		
	print(values["damage"])
	
	return values
