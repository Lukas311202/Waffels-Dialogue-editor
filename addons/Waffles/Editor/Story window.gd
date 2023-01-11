tool
extends Control


var folder_path = "res://addons/Waffles/Dialogues/"
var dialogues : Array

onready var EDITOR = get_parent().get_parent().get_parent().get_parent()


func _ready():
	dialogues = DialogueFileManager.get_paths_from_folder(folder_path)
	load_dialogues()

func load_dialogues():
	for i in $ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	
	for i in DialogueFileManager.get_paths_from_folder(folder_path):
#		var button = load("res://addons/Waffles/Editor/dialogue_btn.tscn").instance()
#		button.get_node("Button").text = i
#		button.get_node("Button").connect("pressed", self, "change_file", [folder_path+i])
#		button.get_node("erase_btn").connect("pressed", self, "erase_file", [folder_path+i, button])
#		button.get_node("rename_btn").connect("pressed", self, "rename_file", [folder_path+i, button])
#		$ScrollContainer/VBoxContainer.add_child(button)
		add_button(i, folder_path + i)

func add_button(text,filepath, below_node : Node = null):
	var button = load("res://addons/Waffles/Editor/dialogue_btn.tscn").instance()
	button.get_node("Button").text = text
	button.get_node("Button").connect("pressed", self, "change_file", [filepath])
	button.get_node("erase_btn").connect("pressed", self, "erase_file", [filepath, button])
	button.get_node("rename_btn").connect("pressed", self, "rename_file", [filepath, button])
	button.get_node("copy").connect("pressed", self, "set_clipboard", [filepath])
	$ScrollContainer/VBoxContainer.add_child(button) if !below_node else $ScrollContainer/VBoxContainer.add_child_below_node(below_node, button)

func set_clipboard(filepath):
	print("copy ", filepath)
	OS.clipboard = filepath

func change_file(filepath):
	EDITOR.GRAPHEDIT.change_file(filepath)

func rename_file(filepath, btn : Control):
	if EDITOR.GRAPHEDIT.current_file == filepath: EDITOR.GRAPHEDIT.save_file(filepath)
	print("rename files")
	EDITOR.NAMING_FIELD.type_name()
	yield(EDITOR.NAMING_FIELD, "result_finished")
	if EDITOR.NAMING_FIELD.result is int:
		if EDITOR.NAMING_FIELD.result == FAILED:
			print("renaming cancelled")
			return
	var dir = Directory.new()
	if dir.open(DialogueFileManager.DIALOGUE_DIR) == OK:
		dir.rename(filepath, DialogueFileManager.DIALOGUE_DIR + EDITOR.NAMING_FIELD.result + ".json")
	
	var old_filepath = filepath
	filepath = DialogueFileManager.DIALOGUE_DIR + EDITOR.NAMING_FIELD.result + ".json"
#	add_button(EDITOR.NAMING_FIELD.result + ".json", filepath, btn)
#	btn.queue_free()
	
	if EDITOR.GRAPHEDIT.current_file == old_filepath: 
#		erase_file(old_filepath, null)
		EDITOR.GRAPHEDIT.change_file(filepath, false)
	load_dialogues()
		
	

func erase_file(filepath, btn):
	var dir = Directory.new()
	if dir.open(DialogueFileManager.DIALOGUE_DIR) == OK:
		if dir.file_exists(filepath):
			dir.remove(filepath)
			if btn: btn.queue_free()
	else: print("could not find the folder, erase aborted")

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
