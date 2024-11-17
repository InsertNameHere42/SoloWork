extends Camera2D

@export var decay : float = 1
@export var maxOffset : Vector2 = Vector2(100, 75)
@export var maxRoll : float = 0.1
@export var follow_node : Node2D

var trauma : float = 0.0
var traumaPower : int = 2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if follow_node:
		global_position = follow_node.global_position
		
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()


func addTrauma(amount : float) -> void:
	trauma = min(trauma + amount, 1.0)
	
func shake() -> void:
	var amount = min(pow(trauma, traumaPower), 0.1)
	rotation = maxRoll * amount * randf_range(-1, 1)
	offset.x = maxOffset.x * amount * randf_range(-1, 1)
	offset.y = maxOffset.y * amount * randf_range(-1, 1)
