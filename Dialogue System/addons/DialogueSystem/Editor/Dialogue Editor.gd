tool
extends Control

onready var FILE_BUTTON = $Panel/HBoxContainer/MenuButton
onready var EDITOR_BUTTON = $"Panel/HBoxContainer/Editor button"

onready var GRAPHEDIT = $MarginContainer/GraphEdit
onready var CHARACTER_EDITOR = $"MarginContainer/Character Window"
onready var STORY_WINDOW = $"MarginContainer/file selection/Panel/Story window"
onready var CHARACTER_WINDOW = $"MarginContainer/file selection/Panel/character window"

onready var NAMING_FIELD = $"naming field"
onready var INFO_PANEL = $"info panel"

const character_file = "res://addons/DialogueSystem/character.json"

func _ready():
	DialogueFileManager.load_characters()
	FILE_BUTTON.get_popup().connect("id_pressed", self, "file_button_pressed")
	EDITOR_BUTTON.get_popup().connect("id_pressed", self, "editor_button_pressed")
	GRAPHEDIT.connect("file_saved", INFO_PANEL, "show_save_icon")
	GRAPHEDIT.connect("changes_made", INFO_PANEL, "hide_save_icon")

func editor_button_pressed(id):
	var button
	
	match id:
		0:
			#default dialogue
			button = load("res://addons/DialogueSystem/Editor/Nodes/Dialogue Node.tscn").instance()
		1:
			#option
			button = load("res://addons/DialogueSystem/Editor/Nodes/QuestionNode.tscn").instance()
		2:
			#start node
			button = load("res://addons/DialogueSystem/Editor/Nodes/StartNode.tscn").instance()
		3:
			#End node
			button = load("res://addons/DialogueSystem/Editor/Nodes/EndNode.tscn").instance()
		4:
			#signal node
			button = load("res://addons/DialogueSystem/Editor/Nodes/SignalNode.tscn").instance()
	
	button.connect("close_request", self, "delete_node", [button])
	button.connect("resize_request", self, "resize_node", [button])
	button.offset += GRAPHEDIT.scroll_offset
	GRAPHEDIT.add_child(button)
	GRAPHEDIT.emit_signal("changes_made")

func resize_node(new_minsize,node : GraphNode):
	node.rect_size = new_minsize

func delete_node(node : GraphNode):
	node.queue_free()
	print("delete node")

func file_button_pressed(id):
	match id:
		0:
			#test button was pressed
			$"MarginContainer/file selection/Panel/character window".test()
			print("test button was pressed")
		1:
			#create new File
			create_dialogue_file()
		3:
			#save graph tree into file
			save_dialogue()
		4:
			#refresh
			DialogueFileManager.load_characters()

func create_character():
	print("create new character")
	var existing_character : Dictionary = DialogueFileManager.load_characters()
	var id = 0
	while existing_character.has(str(id)):
		id += 1
	
	NAMING_FIELD.type_name()
	yield(NAMING_FIELD, "result_finished")
	var file_name = NAMING_FIELD.result
	if file_name == "":
		#cancel process
		print("cancel process")
	else:
	
		existing_character[str(id)] = {
			"name": file_name,
			"description":"",
			"display_name":file_name,
			"portrait":[],
			"color":Color.white
			}
		print(existing_character)
		DialogueFileManager.save_json(character_file, existing_character)
		CHARACTER_WINDOW.refresh()
		DialogueFileManager.load_characters()


func create_dialogue_file():
	
	var data = {
		"title":"testfile"
	}
	
	NAMING_FIELD.type_name()
	yield(NAMING_FIELD, "result_finished")
	var file_name = NAMING_FIELD.result
	
	if file_name == "":
		#cancel
		print("cancel process")
	else:
		#accept
	
		var file = File.new()
		file.open("res://addons/DialogueSystem/Dialogues/" + file_name+".json", file.WRITE)
		#file.store_line(to_json(data))
		file.close()
		print("file was created ")
		STORY_WINDOW.refresh()

func save_dialogue():
	GRAPHEDIT.save_file()

func _on_Button_pressed():
	print("test buttom was pressed")

func open_window(window):
	print("window ",window.name)
	for i in get_tree().get_nodes_in_group("editor"):
		i.hide()

func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	GRAPHEDIT.connect_node(from, from_slot, to, to_slot)
	if GRAPHEDIT.get_node(from).filename != "res://addons/DialogueSystem/Editor/Nodes/QuestionNode.tscn":
		GRAPHEDIT.get_node(from).next = to
	else:
		GRAPHEDIT.get_node(from).next[from_slot] = to
		GRAPHEDIT.get_node(from).correct_connections(GRAPHEDIT.get_connection_list())
		print("connection from ",from, " (fromslot: ",from_slot," ) to", to, "(to_slot: ",to_slot," )")
	GRAPHEDIT.emit_signal("changes_made")


func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	GRAPHEDIT.disconnect_node(from, from_slot,to,to_slot)
	GRAPHEDIT.get_node(from).next = null
	
	if GRAPHEDIT.get_node(from).filename == "res://addons/DialogueSystem/Editor/Nodes/QuestionNode.tscn":
		GRAPHEDIT.get_node(from).correct_connections(GRAPHEDIT.get_connection_list())
	if GRAPHEDIT.get_node(to).filename == "res://addons/DialogueSystem/Editor/Nodes/QuestionNode.tscn":
		GRAPHEDIT.get_node(to).correct_connections(GRAPHEDIT.get_connection_list())
	
	print(from, " and ", to, " got disconnected")
	GRAPHEDIT.emit_signal("changes_made")


func create_new_object():
	pass # Replace with function body.
