extends CharacterBody2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hurt_box: HurtBox = $HurtBox

@export var speed := 600.0
var direction : Vector2 = Vector2.LEFT # default direction

func _process(delta):
	var collisionResult = move_and_collide(direction*speed*delta)
	if collisionResult != null:
		queue_free()


func setDamage(dmg):
	hurt_box.damage = dmg
func remove():
	queue_free()
func reflect():
	hurt_box.collision_mask = 128
	speed *= 2
	direction *= -1
