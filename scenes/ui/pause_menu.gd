extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var panel_container = %PanelContainer
@onready var resume_button = %ResumeButton
@onready var options_button = %OptionsButton
@onready var main_menu_button = %MainMenuButton

var options_scene = preload("res://scenes/ui/options_menu.tscn")

var is_closing = false

func _ready():
	get_tree().paused = true
	animation_player.play("default")
	panel_container.pivot_offset = panel_container.size / 2
	resume_button.pressed.connect(on_resume_button_pressed)
	options_button.pressed.connect(on_options_button_pressed)
	main_menu_button.pressed.connect(on_main_menu_button_pressed)
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func _unhandled_input(event):
	if event.is_action_pressed("paused"):
		print("closing")
		close()
		get_viewport().set_input_as_handled()
		
func close():
	if is_closing:
		return
	
	print("closing")
	is_closing = true
	animation_player.play_backwards("default")
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	await tween.finished
	
	get_tree().paused = false
	queue_free()
	
func on_resume_button_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	close()

func on_options_button_pressed():
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))
	
func on_main_menu_button_pressed():
	get_tree().paused = false
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")

func on_options_closed(scene: Node):
	scene.queue_free()
