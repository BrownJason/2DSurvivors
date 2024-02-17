extends Area2D
class_name HurtBoxComponent

@export var health_component: HealthComponent 

func _ready():
	area_entered.connect(on_area_entered)
	
func on_area_entered(area: Area2D):
	if not area is HitBoxComponent:
		return
	
	if health_component == null:
		return
		
	var hit_box_component = area as HitBoxComponent
	health_component.damage(hit_box_component.damage)
