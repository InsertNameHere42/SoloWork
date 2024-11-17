class_name HitBox
extends Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _init() -> void:
	pass
func disable():
	collision_shape_2d.disabled = true
