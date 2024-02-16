extends Node

var current_experience = 0

func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)

func increment_experience(number: float):
	current_experience += number
	print(current_experience)
	#experience_updated.emit(min(current_experience, target_experience), target_experience)
	#
	#if current_experience >= target_experience:
		#current_level += 1
		#current_experience -= target_experience
		#target_experience *= EXPERIENCE_GROWTH_FACTOR
		#experience_updated.emit(current_experience, target_experience)

func on_experience_vial_collected(number: float):
	increment_experience(number)
