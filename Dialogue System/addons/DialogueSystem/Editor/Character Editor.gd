tool
extends Panel

var current_id = -1
var current_char

onready var PORTRAIT = $ScrollContainer/VBoxContainer/portrait
onready var description = $ScrollContainer/VBoxContainer/description
onready var NAME_LABEL = $"ScrollContainer/VBoxContainer/first name"
onready var DISPLAY_LABEL = $"ScrollContainer/VBoxContainer/display name"
onready var file_selection = $FileDialog
onready var COLOR_PICKER = $"ScrollContainer/VBoxContainer/name color/colorpicker"

func edit_character(charater_id):
	#save previous character if one exists
	if current_char != null:
		save_character()
	
	PORTRAIT.texture = null
	print(charater_id)
	current_char = DialogueFileManager.load_characters().get(str(charater_id))
	current_id = int(charater_id)
	print("edit character")
	owner.open_window(self)
	NAME_LABEL.get_node("LineEdit").text = current_char.name
	DISPLAY_LABEL.get_node("LineEdit").text = current_char.display_name
	
	if current_char.has("color"):
		COLOR_PICKER.color = Color(current_char.color[0],current_char.color[1],current_char.color[2])
	else:
		COLOR_PICKER.color = Color.white
	
	description.text = current_char.description
	load_portrait()
	show()

func load_portrait():
	if current_char.has("portrait"):
		if current_char.portrait.size() > 0:
			PORTRAIT.texture = load(current_char.portrait[0])
		
		for i in PORTRAIT.get_node("HBoxContainer").get_children():
			i.queue_free()
		
		for i in current_char.portrait:
			var button = Button.new()
			button.text = i
			button.connect("pressed", self, "change_portrait", [i])
			PORTRAIT.get_node("HBoxContainer").add_child(button)

func refresh_portraits():
	for i in PORTRAIT.get_node("HBoxContainer").get_children():
			i.queue_free()
		
	for i in current_char.portrait:
		var button = Button.new()
		button.text = i
		button.connect("pressed", self, "change_portrait", [i])
		PORTRAIT.get_node("HBoxContainer").add_child(button)

func change_portrait(filepath):
	PORTRAIT.texture = load(filepath)

func _input(event):
	if visible:
		if event is InputEventKey and event.scancode == KEY_S:
			save_character()

func save_character():
	print("save character")
	var existing_character = DialogueFileManager.load_characters()
	existing_character[str(current_id)] = current_char
	DialogueFileManager.save_json(owner.character_file, existing_character)
	owner.CHARACTER_WINDOW.refresh()


func _on_LineEdit_text_entered(new_text):
	current_char["name"] = new_text


func display_name_entered(new_text):
	current_char["display_name"] = new_text


func _on_description_text_changed():
	current_char["description"] = description.text


func add_new_portrait():
	file_selection.popup()
	pass # Replace with function body.


func _on_FileDialog_file_selected(path):
	if current_char.has("portrait"):
		current_char.portrait.append(path)
	else:
		current_char["portrait"] = [path]
	refresh_portraits()
	print("new portrait was added")
	file_selection.hide()


func _on_LineEdit_popup_closed():
	current_char["color"] = [COLOR_PICKER.color.r,COLOR_PICKER.color.g,COLOR_PICKER.color.b]

