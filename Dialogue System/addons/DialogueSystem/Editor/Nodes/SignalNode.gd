tool
extends GraphNode

var next

func _ready():
	title = name

func save_node() -> Dictionary:
	var data = {
		"filename": filename,
		"rect_x": offset.x,
		"rect_y": offset.y,
		"size_x":rect_size.x,
		"size_y":rect_size.y,
		"content": $LineEdit.text,
		"type":"signal",
		"name":name,
		"next": next
	}
	
	return data

func load_node(data : Dictionary):
	print("load data")
	$LineEdit.text = data.content
