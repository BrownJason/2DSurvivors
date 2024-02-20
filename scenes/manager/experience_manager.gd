extends Node

signal experience_updated(current_experience: float, target_experience: float, leveled: bool)
signal level_up(new_level: int)

const EXPERIENCE_GROWTH_FACTOR = 1.2

var current_experience = 0
var current_level = 1
var target_experience = 5

func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)

func increment_experience(number: float):
	current_experience += number

	if current_experience < target_experience:
		experience_updated.emit(current_experience, target_experience, false)

	while current_experience >= target_experience:
		current_level += 1
		current_experience -= target_experience
		target_experience *= EXPERIENCE_GROWTH_FACTOR
		experience_updated.emit(current_experience, target_experience, true)


func leveled_up():
	level_up.emit(current_level)

func on_experience_vial_collected(number: float):
	increment_experience(number)
