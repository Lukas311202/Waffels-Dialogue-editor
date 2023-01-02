tool
extends GraphNode

var next setget set_next
var editor

func set_next(value):
	next = value
	print(name, " leads to ", next)

func _ready():
	title = name
	load_all_actors()
	$TextEdit.grab_focus()

func load_all_actors():
	#print(DialogueFileManager.characters)
	$character.clear()
	
	var idx = 0
	for i in DialogueFileManager.character_history:
		if DialogueFileManager.character_exists(i):
			$character.add_item(i, idx)
		idx += 1
	$character.select(DialogueFileManager.last_speaker)

func _on_Dialogue_Node_resize_request(new_minsize):
	rect_size = new_minsize

func _on_Dialogue_Node_close_request():
	print("delete node")
	get_parent().emit_signal("delete_nodes_request", [name])
	#disconnect all nodes
	
	#queue_free()

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
		"actor_id":$character.get_item_id($character.selected),
		"portrait_visisble":$portrait.visible
	}
	
	return data

func load_node(data : Dictionary):
	print("load data")
	$TextEdit.text = data.content
	load_all_actors()
#	load_portraits(data.actor_index)
	$portrait.selected = data.portrait
	$portrait.visible = data.portrait_visisble
#	if DialogueFileManager.characters.has(str(data.actor_index)):
	$character.select($character.get_item_index(data.actor_id))


func _on_character_item_selected(index):
	#check if character has a portrait
#	if DialogueFileManager.characters.get(str(index)).get("portrait").size() > 0:
#		$portrait.show()
#		load_portraits(index)
#	else:
#		$portrait.hide()
#		$portrait.clear()
	DialogueFileManager.last_speaker = index

func load_portraits(index):
	$portrait.clear()
	
	for i in DialogueFileManager.characters.get(str(index)).portrait:
		$portrait.add_item(i)
