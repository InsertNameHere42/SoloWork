extends CharacterBody2D
class_name MeleeEnemy

@onready var hit_box: HitBox = $HitBox
@onready var hit_particles: GPUParticles2D = $HitParticles
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var direction_timer: Timer = $DirectionTimer
@onready var hit: AnimationPlayer = $Hit
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var wall_check: RayCast2D = $wallCheck
@onready var aggro: Area2D = $Aggro
@onready var aggroCollider: CollisionShape2D = $Aggro/CollisionShape2D
@onready var attack_check: Area2D = $AttackCheck
@onready var hit_sound: AudioStreamPlayer = $HitSound
@onready var attack_sound: AudioStreamPlayer = $AttackSound

var attacking := false
var canJump := false
var stunned := false
var active = true
var chasing = false
var targetNear = false
@export var speed := 30.0
@export var healthMax := 80.0
@export var damageDealt := 20
@export var shakeStrength := 0.2
@export var knockbackForce := 200
@onready var sword_hurt_box: HurtBox = $SwordHurtBox
var randomSpeed := randf_range(1.0, 3.0)
var health = healthMax
var dir := 1

@export var target: CharacterBody2D

func _ready() -> void:
	sword_hurt_box.damage = damageDealt
	sword_hurt_box.knockback = knockbackForce

func _physics_process(delta: float) -> void:
	if attacking and !stunned:
		attack()

	if wall_check.is_colliding():
		flip()
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
			if target.position.y < position.y-75 and is_on_floor():
				canJump = true
			else:
				canJump = false
	elif !active:
		die()

func takeDamage(damage, knockback):
	if active:
		hit_sound.play()
		velocity = knockback
		hit_particles.restart()
		hit_particles.emitting = true
		owner.shake(shakeStrength)
		health -= damage
		hit.play("Hurt")
		HitStopManager.hitStop(0.1)
		hitStun(0.1)

func die():
	hit.play("Dead")
	active = false
	hit_box.disable()
	await get_tree().create_timer(0.3, true, false, false).timeout
	queue_free()

func _on_direction_timer_timeout() -> void:
	if !chasing:
		flip()
	if canJump:
		jump()
	randomSpeed = randf_range(1, 4)
	direction_timer.wait_time = randf_range(2, 12)
func flip():
	velocity.x = 0
	scale.x = scale.x * -1
	dir = dir * -1
func jump():
	velocity.y = -400
func attack():
	stunned = true
	animation_player.play("Attack")
	await get_tree().create_timer(0.4, true, false, false).timeout
	attack_sound.play()
	await get_tree().create_timer(randf_range(0.3, 0.8), true, false, false).timeout
	stunned = false

func hitStun(time):
	stunned = true
	animation_player.pause()
	await get_tree().create_timer(time, true, false, false).timeout
	stunned = false
	animation_player.play()


func _on_aggro_area_entered(_area: Area2D) -> void:
	targetNear = true

func _on_aggro_area_exited(_area: Area2D) -> void:
	targetNear = false


func _on_attack_check_area_entered(_area: Area2D) -> void:
	attacking = true

func _on_attack_check_area_exited(_area: Area2D) -> void:
	attacking = false
