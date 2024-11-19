extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite: Sprite2D = $Sprite2D
@onready var dash_particles: GPUParticles2D = $DashParticles
@onready var sword_hurt_box: HurtBox = $Sprite2D/SwordHurtBox
@onready var ui: CanvasLayer = $UI
@onready var hit_particles: GPUParticles2D = $HitParticles
@onready var hit: AnimationPlayer = $Hit
@onready var parry_particles: GPUParticles2D = $ParryParticles
@onready var sfx: Node = $SFX

@export var maxSpeed := 600.0
@export var acceleration := 1200
@export var friction := 10
@export var hp := 150.0

signal shifted

var place := 0
var shiftCoolDown := 3.0
var idle: = true
var running := false
var jumpingUp := false
var falling := false
var parrying := false
const JUMP_VELOCITY := -400.0
var jumpAttackCooldown := 1.0
var parryLength := 0.3
var attack1 = 0.5


func _ready():
	ui.init_health(hp)

func _physics_process(delta: float) -> void:
	ui.setShift(shiftCoolDown)
	
	if jumpAttackCooldown < 0.5:
		jumpAttackCooldown+=delta
	else:
		dash_particles.emitting = false

	if parrying == false:
		idle = is_on_floor() and velocity.x == 0
		running = is_on_floor() and velocity.x != 0
		jumpingUp = not is_on_floor() and velocity.y < 0
		falling = not is_on_floor() and velocity.y >= 0
	animation_tree.set("parameters/conditions/idle", idle)
	animation_tree.set("parameters/conditions/running", running)
	animation_tree.set("parameters/conditions/jumpingUp", jumpingUp)
	animation_tree.set("parameters/conditions/falling", falling)
	
	if shiftCoolDown >= 3:
		if Input.is_action_just_released("Special"):
			shift()
			shiftCoolDown=0
	else:
		shiftCoolDown+=delta
	if Input.is_action_just_pressed("Attack"):
		attack()
	if parryLength>= 0.15:
		parrying = false
	if parryLength >= 0.3:
		if Input.is_action_just_pressed("Block"):
			parry()
	else:
		parryLength+=delta
		if is_on_floor():
			velocity.x = 0
	if attack1 < 0.5:
		attack1 += delta


	
	if velocity.x > 0:
		direction(1)
	elif velocity.x < 0:
		direction(-1)
	if is_on_floor():
		if velocity.x != 0:
			pass
			if (not Input.is_action_pressed("Left") and not Input.is_action_pressed("Right")) or attack1 < 0.5:
				velocity.x = move_toward(velocity.x, 0, friction)

				
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_pressed("Right") and parrying == false and attack1 >= 0.5:
		if velocity.x<0:
			accelerate(delta*2)
		else:
			accelerate(delta)
	if Input.is_action_pressed("Left") and parrying == false and attack1 >= 0.5:
		if velocity.x>0:
			accelerate(delta*-2)
		else:
			accelerate(-1 * delta)

	# Handle jump.
	if Input.is_action_just_pressed("Up") and is_on_floor() and parrying == false:
		velocity.y = JUMP_VELOCITY
	


	move_and_slide()
func accelerate(magnitude):
	if abs(velocity.x) > maxSpeed:
		velocity.x = move_toward(velocity.x, maxSpeed, 10)
	else:
		velocity.x += acceleration * magnitude
func direction(dir):
	if dir>0:
		sprite.scale.x = 1
	else:
		sprite.scale.x = -1

	

func attack():
	parrying = false
	if is_on_floor():
		if attack1 >= 0.5:
			setDmg(10)
			attack1 = 0
			animation_tree.get("parameters/playback").travel("Attack1")
		else:
			setDmg(20)
			animation_tree.get("parameters/playback").travel("Attack3")
			attack1 = 0.5
	elif jumpAttackCooldown >= 0.5:
		setDmg(7.5)
		if Input.is_action_pressed("Right"):
			velocity.x = 600
			dash_particles.scale.x = 1
			dash_particles.emitting = true
			velocity.y = 0
		elif Input.is_action_pressed("Left"):
			velocity.x = -600
			dash_particles.scale.x = -1
			dash_particles.emitting = true
			velocity.y = 0
		animation_tree.get("parameters/playback").travel("JumpAttack")
		jumpAttackCooldown = 0
		
func parry():
	parryLength = 0
	parrying = true
	animation_tree.get("parameters/playback").travel("Parry")

func setDmg(dmg):
	sword_hurt_box.setDamage(dmg)

func shift():
	owner.shake(0.3)

	sfx.playParry()
	if place==0:
		self.position.y -= 1584
		shifted.emit(-1584)
		place = 1
	else:
		self.position.y += 1584
		shifted.emit(1584)
		place = 0
	
func takeDamage(damage, kb):
	if parrying:
		parry_particles.restart()
		parry_particles.emitting = true
		hp = min(150, hp+damage/2)
		ui.setHP(hp)
		hit.play("ParryFlash")
		sfx.playParry()
		HitStopManager.hitStop(0.4)
		parryLength = 0.3
		return true
	else:
		if !is_on_floor():
			velocity = kb*4
		hit_particles.restart()
		hit_particles.emitting = true
		hp -= damage
		ui.setHP(hp)
		owner.shake(0.2)
		hit.play("HitFlash")
		sfx.playHit()
		HitStopManager.hitStop(0.3)
		if(hp<=0):
			get_tree().change_scene_to_file("scenes/game_over.tscn")
		return false
func knockback():
	if !is_on_floor():
		velocity.x *= -0.8
		velocity.y *= -0.25
	

	
	
