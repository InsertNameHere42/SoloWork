extends CanvasLayer
@onready var hp_bar: TextureProgressBar = $HPBar
@onready var shift_bar: TextureProgressBar = $ShiftBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func init_health(_health):
	hp_bar.init_health(_health)
func setHP(hp):
	hp_bar.setHP(hp) 
func setShift(value):
	shift_bar.value = value * 100
