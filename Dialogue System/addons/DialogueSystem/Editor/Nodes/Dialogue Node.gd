tool
extends GraphNode

var next setget set_next

func set_next(value):
	next = value
	print(name, " leads to ", next)

func _ready():
	title = name
	load_all_actors()

func load_all_actors():
	#print(DialogueFileManager.characters)
	$character.clear()
	
	for i in DialogueFileManager.characters:
		if !DialogueFileManager.characters[i].has("name"):
			continue
		$character.add_item(DialogueFileManager.characters[i].name)

func _on_Dialogue_Node_resize_request(new_minsize):
	rect_size = new_minsize

func _on_Dialogue_Node_close_request():
	queue_free()

func save_node() -> Dictionary:
	var data = {
		"filename": filename,
		"rect_x": offset.x,
		"rect_y": offset.y,
		"size_x":rect_size.x,
		"size_y":rect_size.y,
		"content": $TextEdit.text,
		"type":"dialogue",
		"name":name,
		"next": next,
		"portrait":$portrait.selected,
		"actor_index":$character.selected,
		"portrait_visisble":$portrait.visible
	}
	
	return data

func load_node(data : Dictionary):
	print("load data")
	$TextEdit.text = data.content
	load_all_actors()
	load_portraits(data.actor_index)
	$portrait.selected = data.portrait
	$portrait.visible = data.portrait_visisble
	if DialogueFileManager.characters.has(str(data.actor_index)):
		$character.select(data.actor_index)
	else:
		$character.select(0)


func _on_character_item_selected(index):
	#check if character has a portrait
	if DialogueFileManager.characters.get(str(index)).get("portrait").size() > 0:
		$portrait.show()
		load_portraits(index)
	else:
		$portrait.hide()
		$portrait.clear()

func load_portraits(index):
	$portrait.clear()
	
	for i in DialogueFileManager.characters.get(str(index)).portrait:
		$portrait.add_item(i)
