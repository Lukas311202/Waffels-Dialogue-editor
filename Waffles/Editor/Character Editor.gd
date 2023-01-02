tool
extends Panel

var current_id = -1
var current_char
var current_data : Dictionary

onready var CONTAINER = $ScrollContainer/VBoxContainer

const FORM_TYPES = {
	"textfield":"res://addons/Waffles/Editor/forms/Textfield.tscn",
	"description":"",
	"dialogue_selection":"res://addons/Waffles/Editor/forms/Dialogue_selection.tscn"
}

func edit_character(char_path : String):
	if current_char: DialogueFileManager.save_character(current_char, current_data)
	current_char = char_path
	current_data = DialogueFileManager.load_character(current_char)
	check_missing_data(current_data)
#	print("current data ")
#	for key in current_data.keys():
#		print(key, ": ", current_data.get(key))
	load_current_data()
	show()

#func load_textfield(key):
#	var form = load("res://addons/Waffles/User Interface/Textfield.tscn").instance()
#	form.get_node("Label").text = key
#	form.get_node("LineEdit").connect("text_changed", self, "update_current_data", [key])
#	form.get_node("LineEdit").text = current_data.get(key)
#	CONTAINER.add_child(form)
#
#func load_dialogue_selection(key):
#	var form = load("res://addons/Waffles/User Interface/Dialogue_selection.tscn").instance()
#	form.get_node("Label").text = key
#	form.get_node("LineEdit").connect("text_changed", self, "update_current_data", [key])
#	form.get_node("LineEdit").text = current_data.get(key)
#	CONTAINER.add_child(form)

func load_current_data():
	for i in CONTAINER.get_children():
		i.queue_free()
	
	var scheme = DialogueFileManager.get_npcs_scheme()
	for key in scheme:
		var form = load(FORM_TYPES.get(scheme.get(key).type)).instance()
		CONTAINER.add_child(form)
		form.character_window = self
		form.Load(key, current_data.get(key))
	
#	load_custom_fields()
	

func load_custom_fields():
	var delete = false
	for i in CONTAINER.get_children():
		if i is HSeparator:
			delete = true
		if delete: i.queue_free()
	
	CONTAINER.add_child(HSeparator.new())
	var lbl = Label.new()
	lbl.text = "Custom"
	CONTAINER.add_child(lbl)
	
	for i in current_data.custom:
		var value : Dictionary = current_data.custom.get(i)
		var form = load("res://addons/Waffles/Editor/forms/Textfield.tscn").instance()
		form.custom_field = true
		form.character_window = self
		CONTAINER.add_child(form)
		form.Load(i, value)
	
	var btn = Button.new()
	btn.text = "add custom"
	btn.connect("pressed", self, "add_custom_field")
	CONTAINER.add_child(btn)

func _input(event):
	if visible:
		if event is InputEventKey and event.scancode == KEY_S and current_char != null:
			DialogueFileManager.save_character(current_char, current_data)

func add_custom_field():
	var field_title = DialogueEditor.input_text()
	print("field title is ", field_title)
	current_data.custom[field_title] = {"type":"textfield", "default":""}
	load_custom_fields()

#checks the data for missing data that maybe was added after the character was created and fills with default value
func check_missing_data(data : Dictionary):
	var scheme = DialogueFileManager.get_npcs_scheme()
	for i in scheme:
		if !data.has(i):
			#missing data found fill with default thing
			data[i] = scheme.get(i).default

func update_current_data(value , key):
	current_data[key] = value

func update_current_custom_data(value, key):
	current_data.custom[key] = value
