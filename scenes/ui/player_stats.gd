extends CanvasLayer

@onready var crit_chance_label = %CritChanceLabel
@onready var crit_damage_label = %CritDamageLabel
@onready var close_button = %CloseButton

func _ready():
	close_button.pressed.connect(on_close_button_pressed)
	update_stats()

func update_stats():
	crit_chance_label.text = "%2.2f%%" % ((0.05 + (MetaProgression.get_upgrade_count("critical_chance") * 0.05)) * 100)
	crit_damage_label.text = "%2.2f%%" % ((1.5 + (MetaProgression.get_upgrade_count("critical_damage") * 0.10)) * 100)

func on_close_button_pressed():
	hide()
