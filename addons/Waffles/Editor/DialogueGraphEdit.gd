tool
extends GraphEdit

var current_file : String
onready var EDITOR = owner

signal file_saved
signal changes_made

func load_data(new_file : String):
	current_file = new_file
	var data = DialogueFileManager.load_json(current_file)
	var old_name_dict = {} #on node creation saves the old name so that the connections can be established
	
	var delete_idx = 0
	for child in get_children():
		if child.is_in_group("graph_node"):
			child.name = "remove_"+str(delete_idx)
			child.queue_free()
		delete_idx += 1
	clear_connections()
	
	#create all nodes
	if data.has("node_data"):
		for node in data.node_data:
			var graph_node = load(node.filename).instance()
			add_child(graph_node)
			graph_node.load_node(node)
			graph_node.offset = Vector2(node.rect_x, node.rect_y)
			graph_node.rect_size = Vector2(node.size_x, node.size_y)
			old_name_dict[node.name] = graph_node.name
	
	#establish connections
	if data.has("connections"):
		for i in data.connections:
			var correct_from_name = old_name_dict[i.from]
			var correct_to_name = old_name_dict[i.to]
			if get_node(correct_from_name).filename != "res://addons/Waffles/Editor/Nodes/QuestionNode.tscn":
				get_node(correct_from_name).next = correct_to_name
			else:
				#since QuestionNode can have multiple next connections it is a array and not a string
				get_node(correct_from_name).next[i.from_port] = correct_to_name
			#print(correct_name)
			connect_node(correct_from_name, i.from_port, correct_to_name, i.to_port)

func delete_current_file():
	var dir = Directory.new()
	dir.open("res://addons/Waffles/Dialogues/")
	dir.remove(current_file)
	EDITOR.STORY_WINDOW.refresh()
	current_file = ""
	clear_scene()
	print("file was deleted")

func clear_scene():
	for child in get_children():
		if child.is_in_group("graph_node"):
			child.queue_free()
	clear_connections()
	EDITOR.INFO_PANEL.get_node("Label").text = ""

func save_file(filepath=current_file):
	var file = File.new()
	file.open(filepath, file.WRITE)
	
	var data = {}
	var node_data = []
	
	for node in get_children():
		#print("name: ", node.name)
		if node.has_method("save_node"):
			#print("save ", node.name)
			node_data.append(node.save_node())
	
	data["node_data"] = node_data
	data["connections"] = get_connection_list()
	
	file.store_line(to_json(data))
	file.close()
	emit_signal("file_saved")
	#print("save file")

func _input(event):
	if visible:
		if event is InputEventKey and event.scancode == KEY_S:
			save_file()

func change_file(new_file : String, auto_save_old_file = true):
#	EDITOR.open_window(self)
	show()
	print("change file to ", new_file)
	#1. save old stuff
	if current_file != "" and auto_save_old_file:
		save_file(current_file)
	#2. load new stuff
	var new_file_name = new_file
#	new_file_name.erase(0,new_file_name.find_last("/"))
	EDITOR.INFO_PANEL.get_node("Label").text = new_file_name
	load_data(new_file)


func _on_GraphEdit__end_node_move():
	emit_signal("changes_made")
