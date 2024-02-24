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
	var damage_increase = MetaProgression.get_upgrade_count("damage_increase")
	var critical_chance_increase = MetaProgression.get_upgrade_count("critical_chance")
	var critical_damage_increase = MetaProgression.get_upgrade_count("critical_damage")

func get_damage_increase_calculations() -> Dictionary:
	damage_info["base_damage"] = (base_damage + (base_damage * damage_increase * 0.1))
	damage_info["base_critical_chance"] = base_critical_chance + (critical_chance_increase * 0.05)
	damage_info["base_critical_damage"] = base_critical_damage + (critical_damage_increase * 0.10)
		
	return damage_info
