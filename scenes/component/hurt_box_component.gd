extends Area2D
class_name HurtBoxComponent

signal hit

@export var health_component: HealthComponent
var float_text_scene: PackedScene = preload("res://scenes/ui/floating_text.tscn")

func _ready():
	area_entered.connect(on_area_entered)
	
func on_area_entered(area: Area2D):
	if not area is HitBoxComponent:
		return
	
	if health_component == null:
		return
		
	var hit_box_component = area as HitBoxComponent
	health_component.damage(hit_box_component.damage)
	
	var floating_text = float_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	floating_text.global_position = global_position + Vector2.UP * 16
	
	var color = Color.WHITE
	print(hit_box_component.is_crit)
	if hit_box_component.is_crit:
		color = Color.RED
	
	var format_string = "%0.1f"
	if round(hit_box_component.damage) == hit_box_component.damage:
		format_string = "%0.0f"
	floating_text.start(format_string % hit_box_component.damage, color)
	hit.emit()
