extends CharacterBody2D
class_name Boss

@onready var hit_box: HitBox = $HitBox
@onready var hit_particles: GPUParticles2D = $HitParticles
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit: AnimationPlayer = $Hit
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var aggro: Area2D = $Aggro
@onready var attack_check: Area2D = $AttackCheck
@onready var hit_sound: AudioStreamPlayer = $HitSound
@onready var attack_sound: AudioStreamPlayer = $AttackSound

var attacking := false
var stunned := false
var active = true
var chasing = false
var targetNear = false
@export var speed := 20
@export var healthMax := 200
@export var damageDealt := 30
@export var shakeStrength := 0.2
@export var knockbackForce := 300
@onready var sword_hurt_box: HurtBox = $SwordHurtBox
var randomSpeed := randf_range(1.0, 2.0)
var health = healthMax
var dir := 1

@export var target: CharacterBody2D

func _ready() -> void:
	sword_hurt_box.damage = damageDealt

func _physics_process(delta: float) -> void:
	if attacking and !stunned:
		attack()

	if health <= 0:
		die()
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.x = 0
	if stunned:
		velocity.x = move_toward(velocity.x, 0, 20)
	if targetNear:
		chasing = true
		
		
		
	move(delta)
	

		
	move_and_slide() 
	
func move(delta):
	if active and !stunned:
		animation_player.play("Walk")
		if !chasing:
			velocity.x += dir * speed * delta
		else:
			var dirToPlayer = position.direction_to(target.position) * speed * randomSpeed
			if dir != abs(dirToPlayer.x) / dirToPlayer.x:
				flip()
			if global_position.distance_to(target.position) > 50:
				velocity.x = dirToPlayer.x 
	elif !active:
		die()

func takeDamage(damage, knockback):
	if active:
		hit_sound.play()
		stunned = true
		animation_player.pause()
		hit_particles.restart()
		hit_particles.emitting = true
		owner.shake(shakeStrength)
		health -= damage
		hit.play("Hurt")
		animation_player.play("RESET")
		HitStopManager.hitStop(0.1)
		await get_tree().create_timer(1, true, false, true)
		stunned = false
		animation_player.play()

func die():
	hit.play("Dead")
	active = false
	hit_box.disable()
	await get_tree().create_timer(0.3, true, false, true).timeout
	queue_free()

func flip():
	velocity.x = 0
	scale.x = scale.x * -1
	dir = dir * -1
func jump():
	velocity.y = -400
func attack():
	stunned = true
	animation_player.play("Attack")
	await get_tree().create_timer(0.5, true, false, false).timeout
	attack_sound.play()
	stunned = false

func _on_attack_check_area_entered(_area: Area2D) -> void:
	attacking = true

func _on_attack_check_area_exited(_area: Area2D) -> void:
	await get_tree().create_timer(randf_range(0.4, 0.9), true, false, false).timeout
	attacking = false
