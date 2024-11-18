extends Control
@onready var parallax_background: ParallaxBackground = $ParallaxBackground


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	parallax_background.scroll_offset.x -= 400*delta


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("scenes/main.tscn")
