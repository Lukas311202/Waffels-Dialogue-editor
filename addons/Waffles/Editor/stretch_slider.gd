tool
extends HSlider


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.hide()
	$Panel.hide()
	value = get_parent().size_flags_stretch_ratio
	min_value = 0.1
	max_value = 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_stretch_slider_value_changed(value):
	get_parent().size_flags_stretch_ratio = value
	$Label.show()
	$Panel.show()
	$Label.text = str(value)


func _on_stretch_slider_drag_ended(value_changed):
	$Label.hide()
	$Panel.hide()
