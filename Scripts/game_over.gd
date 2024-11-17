extends Control
@onready var timer = $Timer
@onready var countdown = $Countdown
@onready var parallax_background: ParallaxBackground = $ParallaxBackground


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	countdown.text = "Restarting in: " + str(int(timer.time_left))
	parallax_background.scroll_offset.x -= 400*delta


func _on_timer_timeout():
	get_tree().change_scene_to_file("scenes/main_menu.tscn")
