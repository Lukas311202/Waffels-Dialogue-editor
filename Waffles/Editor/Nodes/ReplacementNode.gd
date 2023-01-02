tool
extends GraphNode

var next
const NODE_FOLDER = "res://addons/Waffles/Editor/Nodes/"

func _ready():
	list_all_nodes()

func get_all_nodes():
	var result := []
	var dir = Directory.new()
	if dir.open(NODE_FOLDER) == OK:
		dir.list_dir_begin()
		var filepath = dir.get_next()
		while filepath != "":
			if ".tscn" in filepath and !(name in filepath) and "Node" in filepath:
				result.append(filepath)
			filepath = dir.get_next()
		dir.list_dir_end()
	return result

func list_all_nodes():
	for i in $VBoxContainer.get_children():
		i.name = "deleteMe" #actually required, cause the names of the deleted nodes still remain in the system and you can't name new ones after the old
		i.queue_free()
	
	for i in get_all_nodes():
		var btn = Button.new()
		btn.text = i
		btn.connect("pressed", self, "add_node", [i])
		$VBoxContainer.add_child(btn)

func add_node(node_path : String):
	var node = load(NODE_FOLDER+node_path).instance()
	node.offset = offset
	get_parent().add_child(node)
	for i in get_parent().get_connection_list():
		if i.from == name:
			get_parent().connect_node(node.name, 0, i.to, i.to_port)
		elif i.to == name:
			get_parent().connect_node(i.from, i.from_port, node.name, 0)
		
	emit_signal("close_request") #deletes the node

#since this thing is only temporaly to quickly select a node, it will actually safe dialogue data
func save_node() -> Dictionary:
	var data = {
		"filename": "res://addons/Waffles/Editor/Nodes/Dialogue Node.tscn",
		"rect_x": offset.x,
		"rect_y": offset.y,
		"size_x":rect_size.x,
		"size_y":rect_size.y,
		"content": "",
		"type":"dialogue",
		"name":name,
		"next": next,
		"portrait":0,
		"actor_index":0,
		"portrait_visisble":false
	}
	
	return data

func _on_ReplacementNode_close_request():
	print("delete node")
	get_parent().emit_signal("delete_nodes_request", [name])


func _on_ReplacementNode_resize_request(new_minsize):
	rect_size = new_minsize
