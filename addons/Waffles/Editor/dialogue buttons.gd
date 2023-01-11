tool
extends MenuButton

func _ready():
	get_popup().connect("id_pressed", self, "pressed")

func pressed(id):
	get_parent().editor_button_pressed(id)

func _input(event):
	if event.is_action_pressed("right_mouse"):
		print("show button")
		show()
		#
