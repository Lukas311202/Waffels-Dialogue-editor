tool
extends Control


var file_path = "res://addons/Waffles/character.json"
var data : Dictionary
onready var EDITOR = get_parent().get_parent().get_parent().get_parent()
onready var SCROLL_CONTAINER = $ScrollContainer

func _ready():
	refresh()

func refresh():
	print("refresh")
	load_characters()

func load_characters():
	for i in $ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	
	for npc in DialogueFileManager.get_all_characters_path(false):
		var only_name = npc
		var btn = load("res://addons/Waffles/Editor/character_btn.tscn").instance()
		btn.get_node("Button").text = only_name
		btn.get_node("Button").connect("pressed", self, "edit_character", [npc])
		btn.get_node("delete_btn").connect("pressed", self, "delete_character", [npc])
		SCROLL_CONTAINER.get_node("VBoxContainer").add_child(btn)
	
#	for i in data:
#		if !data[i].has("name"):
#			continue
#		var button = load("res://addons/Waffles/Editor/character_btn.tscn").instance()
#		button.get_node("Button").text = data[i].name
#		button.get_node("Button").connect("pressed", self, "edit_character", [i])
#		button.get_node("delete_btn").connect("pressed", self, "delete_character", [i])
#		$ScrollContainer/VBoxContainer.add_child(button)

func edit_character(char_path):
	print("edit ", char_path)
	owner.CHARACTER_EDITOR.edit_character(char_path)


func test():
	print(data)
	pass


func add_character():
	get_parent().get_parent().get_parent().get_parent().create_character()


func delete_character(character_path):
	DialogueFileManager.delete_character(character_path)
	refresh()
