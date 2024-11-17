extends Sprite2D

@export var health := 50.0
@onready var hit_particles: GPUParticles2D = $HitParticles
@export var shakeStrength = 0.25
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_box: HitBox = $HitBox


signal shake(shake)
var active = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !active:
		animation_player.play("Dead")
		
	
	if health <= 0:
		active = false
		hit_box.disable()
		await get_tree().create_timer(1, true, false, true).timeout
		owner.die()

func takeDamage(damage):
	if active:
		hit_particles.restart()
		hit_particles.emitting = true
		shake.emit(shakeStrength)
		health -= damage
		if health > 0:
			animation_player.play("hitFlash")
		HitStopManager.hitStop(0.07)
