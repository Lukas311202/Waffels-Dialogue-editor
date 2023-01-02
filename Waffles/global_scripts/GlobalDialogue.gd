extends Node

var interaface
var current_speaker #: npc
const DIALOGUE_PATH = "res://addons/Waffles/Dialogues/"

signal conversation_started
signal conversation_finished

signal custom_signal_emitted(signal_)

func play_dialogue(file : String):
	var dialogue = DialogueFileManager.convert_json_to_dialogue(file)
	interaface.start_conversation(dialogue)

func disconnect_old_character():
	disconnect("conversation_started", current_speaker, "conversation_started")
	disconnect("conversation_finished", current_speaker, "conversation_ended")
	disconnect("custom_signal_emitted", current_speaker, "custom_dialogue_signal")

func start_conversation(dialogue_file : String, character):
	if is_instance_valid(current_speaker): disconnect_old_character()
	current_speaker = character
	connect("conversation_started", character, "conversation_started")
	connect("conversation_finished", character, "conversation_ended")
	connect("custom_signal_emitted", character, "custom_dialogue_signal")
	play_dialogue(dialogue_file)
