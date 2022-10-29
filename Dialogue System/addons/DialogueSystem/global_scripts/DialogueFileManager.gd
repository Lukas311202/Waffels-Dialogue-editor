tool
extends Node

signal conversation_started
var characters

func load_characters(remove_invalid = true):
	characters = load_json("res://addons/DialogueSystem/character.json")
	#print("characters: ", characters)
	var control = characters.duplicate()
	for i in control:
		if control[i] == null:
			characters.erase(str(i))
		else:
			characters[i] =  fill_missing_default_values(characters[i])
	print("characters ",characters)
	return characters

#whenever you add new propertys the old will produce errors since they don't have the old ones, so this function will add default
#values to avoid errors
func fill_missing_default_values(character : Dictionary):
	var result = character.duplicate()
	print("missing values were added")
	return result

func _ready():
	load_characters()

func load_json(filepath):
	var file = File.new()
	file.open(filepath, file.READ)
	return parse_json(file.get_as_text())

func save_json(filepath, data):
	var file = File.new()
	file.open(filepath, file.WRITE)
	#for i in data:
	#	file.store_line(to_json({
	#		i: data[i]
	#	}))
	file.store_line(to_json(data))
	file.close()

func get_paths_from_folder(folder_path : String):
	var files = []
	var dir = Directory.new()
	dir.open(folder_path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and !".import" in file and !".gd" in file:
			files.append(file)

	dir.list_dir_end()

	return files

#returns a dictionary of dialogue actions to execute
func convert_json_to_dialogue(filepath):
	var data = load_json(filepath)
	var node_data = data.node_data
	var access_dict = {} #uses the names as keys to quickly access the data
	var sequence = []
	var next_point = ""
	
	#1. find the node that leads that is connected to the start node
	# also write in the access_dict
	for node in node_data:
		access_dict[node.name] = node
		
		#if "StartNode" in node.name:
			#start node found -> get the first dialogue
		#	print("first point is ", node.next)
		#	next_point = node.next
			
	
	#write the sequence till next has "EndNode" in it
	#while  !"EndNode" in next_point:
	#	sequence.append(access_dict.get(next_point))
	#	next_point = access_dict.get(next_point).next
	
	return access_dict
