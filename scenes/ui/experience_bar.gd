extends CanvasLayer

@export var experience_manager: Node
@onready var progress_bar = $MarginContainer/HBoxContainer/ProgressBar
@onready var level_label = $MarginContainer/HBoxContainer/LevelLabel

var percent = 0.0

func _ready():
	progress_bar.value = 0
	experience_manager.experience_updated.connect(on_experience_updated)
	level_label.text = str(experience_manager.current_level)
	
func on_experience_updated(current_experience: float, target_experience: float):
	percent = current_experience / target_experience
	var tween = create_tween().set_trans(Tween.TRANS_CIRC)
	if current_experience > progress_bar.max_value:
		tween.tween_property(progress_bar, "value", percent, 0.3)
	else:
		tween.tween_property(progress_bar, "value", percent, 0.3).from(0.0)
	level_label.text = str(experience_manager.current_level)

