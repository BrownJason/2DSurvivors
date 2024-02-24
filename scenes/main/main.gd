extends Node

@export var end_screen_scene: PackedScene

var pause_menu_scene = preload("res://scenes/ui/pause_menu.tscn")
@onready var player_stats = %PlayerStats


func _ready():
	%Player.health_component.died.connect(on_player_died)

func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
	MetaProgression.save()

func _unhandled_input(event):
	if event.is_action_pressed("paused"):
		add_child(pause_menu_scene.instantiate())
		get_viewport().set_input_as_handled()
		
	if event.is_action_pressed("stats"):
		player_stats.show()
		get_viewport().set_input_as_handled()
