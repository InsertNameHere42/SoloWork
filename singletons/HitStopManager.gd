extends Node
var regenTimeScale = false

func _process(delta: float) -> void:
	if Engine.time_scale >= 1:
		regenTimeScale = false
	if regenTimeScale:
		Engine.time_scale = move_toward(Engine.time_scale, 1, 10*delta)

func hitStop(time):
	Engine.time_scale = 0
	await get_tree().create_timer(time, true, false, true).timeout
	Engine.time_scale = 1
	
