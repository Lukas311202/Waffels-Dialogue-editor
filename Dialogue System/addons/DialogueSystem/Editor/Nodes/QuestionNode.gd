tool
extends GraphNode

var next = []

func get_content():
	var data = []
	var content = []
	var hidden = []
	var condition = []
	
	for i in get_children():
		if i is HBoxContainer:
			content.append(i.get_node("lineedit").text)
			hidden.append(i.get_node("hiddenCheckBox").pressed)
			condition.append(i.get_node("conditionedit").text)
	
	data.append(content)
	data.append(hidden)
	data.append(condition)
	return data

func save_node() -> Dictionary:
	var content_data = get_content()
	
	var data = {
		"filename": filename,
		"rect_x": offset.x,
		"rect_y": offset.y,
		"size_x":rect_size.x,
		"size_y":rect_size.y,
		"content": content_data[0],
		"hidden":content_data[1],
		"condition":content_data[2],
		"type":"choice",
		"name":name,
		"next": next
	}
	
	return data

func load_node(data : Dictionary):
	print("load data")
	for i in range(data.content.size()):
		add_line(data.content[i], data.hidden[i], data.condition[i])

func add_line(text = "", hidden = false, condition = ""):
	var line = load("res://addons/DialogueSystem/Editor/Nodes/ChoiceLine.tscn").instance()
	line.get_node("lineedit").text = text
	line.get_node("hiddenCheckBox").pressed = hidden
	line.get_node("conditionedit").text = condition
	
	rect_min_size.x = max(380, rect_min_size.x)
	add_child(line)
	rect_min_size.y = max(get_child_count()*40, rect_min_size.y)
	next.append(null)
	set_slot(get_child_count()-1, false, 0,Color.white, true,0,Color.white)

func _on_add_button_pressed():
	print("add new option")
	add_line()

func reset_next():
	next = []
	for i in get_children():
		if i is HBoxContainer:
			next.append(null)

func correct_connections(all_connection : Array):
	reset_next()
	for conn in all_connection:
		if conn.from == name:
			next[conn.from_port] = conn.to

func _on_Question_Node_resize_request(new_minsize):
	rect_size = new_minsize


func _on_Question_Node_close_request():
	queue_free()
