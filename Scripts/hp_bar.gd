extends TextureProgressBar

@onready var damage_bar: ProgressBar = $DamageBar
@onready var timer: Timer = $Timer

var whiteHP := false
var hp = 0 : set = setHP
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if whiteHP and damage_bar.value>hp:
		damage_bar.value = move_toward(damage_bar.value, hp, 75*delta)
	else:
		whiteHP = false

		

func setHP(newHP):
	var prevHP = hp
	hp = min(max_value, newHP)
	value = hp
	
	if hp <= 0:
		visible = false
	if hp<prevHP:
		timer.start()
	else:
		damage_bar.value = hp
	

func init_health(_health):
	hp = _health
	max_value = hp
	value = hp
	damage_bar.max_value = hp
	damage_bar.value = hp
	
func _on_timer_timeout() -> void:
		whiteHP = true
