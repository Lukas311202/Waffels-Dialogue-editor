tool
extends Node

signal conversation_started
var characters
var character_history
var last_speaker = 0

const CHARARACTERS_DIR = "res://addons/Waffles/Characters/"
const SCHEME_PATH = "res://addons/Waffles/npc_data_scheme.json"
const CHARACTER_HISTORY_PATH = "res://addons/Waffles/charcaters_history.json"
const DIALOGUE_DIR = "res://addons/Waffles/Dialogues/"

func get_all_characters():
	var dir = Directory.new()
	if dir.open(CHARARACTERS_DIR) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if ".json" in file_name:
				print("filename is ", file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else: print("error occured. could not read the directory")

func character_exists(character_path : String):
	var result = false
	var dir = Directory.new()
	if dir.open(CHARARACTERS_DIR) == OK:
#		dir.list_dir_begin()
		result = dir.file_exists(character_path)
#		dir.list_dir_end()
	return result

func get_all_characters_path(add_charater_dir = true):
	var paths := []
	var dir = Directory.new()
	if dir.open(CHARARACTERS_DIR) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if ".json" in file_name:
#				print("filename is ", file_name)
				paths.append(CHARARACTERS_DIR+file_name) if add_charater_dir else paths.append(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else: print("error occured. could not read the directory")
	return paths

func load_characters(remove_invalid = true):
	characters = load_json("res://addons/Waffles/character.json")
	#print("characters: ", characters)
	var control = characters.duplicate()
	for i in control:
		if control[i] == null:
			characters.erase(str(i))
		else:
			characters[i] =  fill_missing_default_values(characters[i])
	#print("characters ",characters)
	return characters

#whenever you add new propertys the old will produce errors since they don't have the old ones, so this function will add default
#values to avoid errors
func fill_missing_default_values(character : Dictionary):
	var result = character.duplicate()
#	print("missing values were added")
	return result

func _ready():
	get_all_characters()
	load_characters()
	update_character_history()

func create_character(char_name : String):
	var data = {"name": char_name, "custom":{}}
	
	var file = File.new()
	file.open(CHARARACTERS_DIR + char_name + ".json", File.WRITE)
	var scheme : Dictionary = get_npcs_scheme()
	for key in scheme.keys():
		data[key] = scheme.get(key).default
	print("scheme ", scheme)
	file.store_line(to_json(data))
	file.close()
	print(char_name ," was created")
	update_character_history()
	return OK

func update_character_history():
	print("update character history")
	var file = File.new()
	file.open(CHARACTER_HISTORY_PATH, File.READ_WRITE)
	var line = file.get_as_text()
	var history : Dictionary = parse_json(line) if line != "" else {"history":[]}
	print(line)
	for i in get_all_characters_path(false):
		if !history.history.has(i):
			history.history.append(i)
	file.store_line(to_json(history))
	file.close()
	character_history = history.history

#required path relative to the directory
func delete_character(char_name):
	print("try deleting ", char_name)
	var dir = Directory.new()
	if dir.open(CHARARACTERS_DIR) == OK:
		if dir.file_exists(char_name):
			dir.remove(char_name) 
			print(char_name, " successfully deleted")
		else: print("file not found")
	else:
		print("directory could not be opened")

func save_character(char_path, data):
	print("save ", char_path)
	var file = File.new()
	if !file.file_exists(CHARARACTERS_DIR + char_path):
		print("file is already deleted")
		return
	file.open(CHARARACTERS_DIR + char_path, File.WRITE)
	file.store_line(to_json(data))
	file.close()
#	sprint(char_path ," was saved")
	
	return OK

func load_character(char_path) -> Dictionary:
	var file = File.new()
	file.open(CHARARACTERS_DIR + char_path, File.READ)
	var content = parse_json(file.get_as_text())
	file.close()
	
	return content

func get_npcs_scheme():
	var filepath = SCHEME_PATH
	var file = File.new()
	if !file.file_exists(filepath):
		print("scheme could not be found")
		return FAILED
	file.open(filepath, File.READ)
	var content = parse_json(file.get_as_text())
	file.close()
	return content 

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
func convert_json_to_dialogue(filepath) -> Dictionary:
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
