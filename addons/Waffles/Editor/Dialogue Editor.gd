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

var copied_node : GraphNode
var selected_node : GraphNode

const character_file = "res://addons/Waffles/character.json"

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
			button = load("res://addons/Waffles/Editor/Nodes/Dialogue Node.tscn").instance()
		1:
			#option
			button = load("res://addons/Waffles/Editor/Nodes/QuestionNode.tscn").instance()
		2:
			#start node
			button = load("res://addons/Waffles/Editor/Nodes/StartNode.tscn").instance()
		3:
			#End node
			button = load("res://addons/Waffles/Editor/Nodes/EndNode.tscn").instance()
		4:
			#signal node
			button = load("res://addons/Waffles/Editor/Nodes/SignalNode.tscn").instance()
	
	button.connect("close_request", self, "delete_node", [button])
	button.connect("resize_request", self, "resize_node", [button])
	button.offset += GRAPHEDIT.scroll_offset + Vector2(GRAPHEDIT.rect_size.x/2, GRAPHEDIT.rect_size.y/2)
	GRAPHEDIT.add_child(button)
	button.editor = GRAPHEDIT
	button.rect_position.x += GRAPHEDIT.rect_size.x/2
	button.rect_position.y += GRAPHEDIT.rect_size.y/2
	GRAPHEDIT.emit_signal("changes_made")

func resize_node(new_minsize,node : GraphNode):
	node.rect_size = new_minsize

func delete_node(node : GraphNode):
	print("delete node")
	node.queue_free()

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
#	var existing_character : Dictionary = DialogueFileManager.load_characters()
#	var id = 0
#	while existing_character.has(str(id)):
#		id += 1
#
	NAMING_FIELD.type_name()
	yield(NAMING_FIELD, "result_finished")
	if NAMING_FIELD.result is int:
		if NAMING_FIELD.result == FAILED:
			print("character creation cancelled")
			return
	var file_name = NAMING_FIELD.result
	if DialogueFileManager.create_character(file_name) == OK:
		CHARACTER_WINDOW.refresh()


func create_dialogue_file():
	
	var data = {
		"title":"testfile"
	}
	
	NAMING_FIELD.type_name()
	yield(NAMING_FIELD, "result_finished")
	var file_name = NAMING_FIELD.result
	print(file_name)
	
	var file = File.new()
	file.open("res://addons/Waffles/Dialogues/" + file_name+".json", file.WRITE)
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
	if GRAPHEDIT.get_node(from).filename != "res://addons/Waffles/Editor/Nodes/QuestionNode.tscn":
		GRAPHEDIT.get_node(from).next = to
	else:
		GRAPHEDIT.get_node(from).next[from_slot] = to
		GRAPHEDIT.get_node(from).correct_connections(GRAPHEDIT.get_connection_list())
		print("connection from ",from, " (fromslot: ",from_slot," ) to", to, "(to_slot: ",to_slot," )")
	GRAPHEDIT.emit_signal("changes_made")


func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	GRAPHEDIT.disconnect_node(from, from_slot,to,to_slot)
	GRAPHEDIT.get_node(from).next = null
	
	if GRAPHEDIT.get_node(from).filename == "res://addons/Waffles/Editor/Nodes/QuestionNode.tscn":
		GRAPHEDIT.get_node(from).correct_connections(GRAPHEDIT.get_connection_list())
	if GRAPHEDIT.get_node(to).filename == "res://addons/Waffles/Editor/Nodes/QuestionNode.tscn":
		GRAPHEDIT.get_node(to).correct_connections(GRAPHEDIT.get_connection_list())
	
	print(from, " and ", to, " got disconnected")
	GRAPHEDIT.emit_signal("changes_made")


func create_new_object():
	pass # Replace with function body.


func _on_GraphEdit_delete_nodes_request(nodes):
	print("delete nodes request for ")
	for i in nodes:
		print("# " + i)
		for conn in GRAPHEDIT.get_connection_list():
			if conn.from == i or conn.to == i:
				GRAPHEDIT.disconnect_node(conn.from, conn.from_port, conn.to, conn.to_port)
		GRAPHEDIT.get_node(i).queue_free()


func _on_GraphEdit_connection_to_empty(from, from_slot, release_position):
	#add a new dialogue node
	print("auto add dialogue node")
	var button = load("res://addons/Waffles/Editor/Nodes/ReplacementNode.tscn").instance()
	button.offset += GRAPHEDIT.scroll_offset + release_position - Vector2(button.rect_size.x/2, button.rect_size.y/2) #Vector2(GRAPHEDIT.rect_size.x/2, GRAPHEDIT.rect_size.y/2)
	GRAPHEDIT.add_child(button)
#	button.rect_position = release_position
	GRAPHEDIT.connect_node(from, from_slot, button.name, 0)
	GRAPHEDIT.set_selected(button)
#	button.get_node("TextEdit").grab_focus()
	


func _on_GraphEdit_copy_nodes_request():
	copied_node = selected_node
	if copied_node: print(copied_node.name," copied")


func _on_GraphEdit_paste_nodes_request():
	print("paste ", copied_node.name) if copied_node else print("no node selected to paste")


func _on_GraphEdit_node_selected(node):
	selected_node = node
