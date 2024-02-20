extends CanvasLayer

@export var experience_manager: Node
@onready var progress_bar = $MarginContainer/HBoxContainer/ProgressBar
@onready var level_label = $MarginContainer/HBoxContainer/LevelLabel

var percent = 0.0
var counter = 0

func _ready():
	progress_bar.value = 0
	experience_manager.experience_updated.connect(on_experience_updated)
	level_label.text = str(experience_manager.current_level)
	
func on_experience_updated(current_experience: float, target_experience: float, leveled_ups: bool):
	percent = current_experience / target_experience
	var tween = create_tween().set_trans(Tween.TRANS_CIRC)
	tween.tween_property(progress_bar, "value", percent, 0.5)
	if leveled_ups:
		tween.tween_callback(experience_manager.leveled_up)
	tween.tween_interval(0.2)
	level_label.text = str(experience_manager.current_level)

	
