extends AudioStreamPlayer
class_name RandomizedAudio

var startingPitch = pitch_scale

func randomPitchPlay(from_position=0.0):
	randomize()
	pitch_scale = startingPitch * randf_range(0.8, 1.2)
	play(from_position)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
