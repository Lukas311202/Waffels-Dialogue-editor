tool
extends Control


var folder_path = "res://addons/DialogueSystem/Dialogues/"
var dialogues : Array

onready var EDITOR = get_parent().get_parent().get_parent().get_parent()


func _ready():
	dialogues = DialogueFileManager.get_paths_from_folder(folder_path)
	load_dialogues()

func load_dialogues():
	for i in $ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	
	for i in dialogues:
		var button = Button.new()
		button.text = i
		button.connect("pressed", self, "change_file", [folder_path+i])
		$ScrollContainer/VBoxContainer.add_child(button)

func change_file(filepath):
	EDITOR.GRAPHEDIT.change_file(filepath)

func refresh():
	dialogues = DialogueFileManager.get_paths_from_folder(folder_path)
	load_dialogues()

#loads dialogue data into the graph tree
func load_dialogue(filepath : String):
	print("open dialogue")
	EDITOR.GRAPHEDIT.change_file(filepath)

func covert_json_to_dictionary(file_path : String):
	var file = File.new()
	
	if not file.file_exists(file_path):
		return
	
	file.open(file_path, file.READ)
	var text = file.get_as_text()
	file.close()
	return parse_json(text)


func delete_current_object():
	EDITOR.GRAPHEDIT.delete_current_file()


func create_new_object():
	EDITOR.create_dialogue_file()
