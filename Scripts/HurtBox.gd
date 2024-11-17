class_name HurtBox
extends Area2D

@export var damage := 10.0
@export var knockback := 100


func _init() -> void:
	collision_layer = 1
	
func _on_area_entered(hitbox: HitBox) -> void:
	var direction = global_position.direction_to(hitbox.global_position)
	if owner.has_method("knockback"):
		owner.knockback()
	if hitbox == null:
		return
	if hitbox.owner.has_method("takeDamage"):
		var parried = hitbox.owner.takeDamage(damage, direction*knockback)
		if parried:
			if owner.has_method("reflect"):
				owner.reflect()
		else:
			if owner.has_method("remove"):
				owner.remove()
		
	
func setDamage(dmg):
	damage = dmg
func setKnockback(amount):
	knockback = amount
