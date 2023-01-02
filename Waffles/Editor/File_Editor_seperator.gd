tool
extends VSeparator

var mouse_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(delta):
	if Input.is_action_pressed("ui_cancel") and mouse_over:
		print("drag")


func _on_VSeparator_mouse_entered():
	mouse_over = true


func _on_VSeparator_mouse_exited():
	mouse_over = false
