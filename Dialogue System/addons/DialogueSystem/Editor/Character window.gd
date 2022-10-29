tool
extends Control


var file_path = "res://addons/DialogueSystem/character.json"
var data : Dictionary
onready var EDITOR = get_parent().get_parent().get_parent().get_parent()

func _ready():
	refresh()

func refresh():
	data = DialogueFileManager.load_characters()
	load_characters()

func load_characters():
	for i in $ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	
	for i in data:
		if !data[i].has("name"):
			continue
		var button = Button.new()
		button.text = data[i].name
		button.connect("pressed", self, "edit_character", [i])
		$ScrollContainer/VBoxContainer.add_child(button)

func edit_character(character_id):
	print("edit character")
	owner.CHARACTER_EDITOR.edit_character(character_id)


func test():
	print(data)
	pass


func add_character():
	get_parent().get_parent().get_parent().get_parent().create_character()


func delete_character():
	pass # Replace with function body.
