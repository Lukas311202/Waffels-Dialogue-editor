tool
extends EditorPlugin

const DialogueEditor = preload("res://addons/Waffles/Editor/Dialogue Editor.tscn")

var dialogue_editor_instance

func _enter_tree():
	dialogue_editor_instance = DialogueEditor.instance()
	get_editor_interface().get_editor_viewport().add_child(dialogue_editor_instance)
	make_visible(false)
	
	add_autoload_singleton("DialogueFileManager", "res://addons/Waffles/global_scripts/DialogueFileManager.gd")
	add_autoload_singleton("DialogueConditions", "res://addons/Waffles/global_scripts/DialugueConditions.gd")
	add_autoload_singleton("GlobalDialogue", "res://addons/Waffles/global_scripts/GlobalDialogue.gd")
	add_autoload_singleton("DialogueEditor", "res://addons/Waffles/global_scripts/DialogueEditor.gd")
	
	var ev = InputEventMouseButton.new()
	ev.button_index = BUTTON_RIGHT
	if not InputMap.has_action("right_mouse"):
		InputMap.add_action("right_mouse")
	
	InputMap.action_add_event("right_mouse", ev)


func _exit_tree():
	if dialogue_editor_instance:
		dialogue_editor_instance.queue_free()
		#remove_autoload_singleton("DialogueFileManager")

func has_main_screen():
	return true


func make_visible(visible):
	if dialogue_editor_instance:
		dialogue_editor_instance.visible = visible


func get_plugin_name():
	return "Waffles"


func get_plugin_icon():
	return load("res://addons/Waffles/icon.png")#get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")
