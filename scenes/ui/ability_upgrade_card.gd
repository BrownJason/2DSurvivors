extends PanelContainer

signal selected

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel

var disabled = false

func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
		
func play_discard():
	$AnimationPlayer.play("discard")
		
func play_in(delay: float = 0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play("in")
	
func set_ability_upgrade(upgrade: AbilityUpgrade):
	if upgrade == null:
		return
		
	name_label.text = upgrade.name
	description_label.text = upgrade.description

func selected_card():
	disabled = true
	$AnimationPlayer.play("selected")
	
	for other_card in get_tree().get_nodes_in_group("upgrade_card"):
		if other_card == self:
			continue
		
		other_card.play_discard()
	
	await $AnimationPlayer.animation_finished
	selected.emit()

func on_gui_input(event: InputEvent):
	if disabled:
		return
		
	if event.is_action_pressed("left_click"):
		selected_card()
	
func on_mouse_entered():
	if disabled:
		return
		
	$HoverAnimationPlayer.play("hover")
	var hover_in_tween = create_tween()
	hover_in_tween.tween_property(self,"scale", Vector2(1.2, 1.2), 0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)

func on_mouse_exited():
	if disabled:
		return
		
	var hover_out_tween = create_tween()
	hover_out_tween.tween_property(self,"scale", Vector2.ONE, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
