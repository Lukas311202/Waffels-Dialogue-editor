tool
extends EditorPlugin

const DialogueEditor = preload("res://addons/DialogueSystem/Editor/Dialogue Editor.tscn")

var dialogue_editor_instance

func _enter_tree():
	dialogue_editor_instance = DialogueEditor.instance()
	get_editor_interface().get_editor_viewport().add_child(dialogue_editor_instance)
	make_visible(false)
	
	add_autoload_singleton("DialogueFileManager", "res://addons/DialogueSystem/global_scripts/DialogueFileManager.gd")
	add_autoload_singleton("DialogueConditions", "res://addons/DialogueSystem/global_scripts/DialugueConditions.gd")
	
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
	return "Dialogue Editor"


func get_plugin_icon():
	return load("res://addons/DialogueSystem/icon.png")#get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")
