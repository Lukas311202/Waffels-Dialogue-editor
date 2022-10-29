extends Control

var dialogue : Dictionary
var point = "StartNode"

export (String, FILE, "*.json")var dialogue_path

onready var TEXTLABEL = $Panel/RichTextLabel
onready var TWEEN = $Tween

onready var CHOICE_CONTAINER = $"Panel/choice container"
onready var ACTOR_LABEL = $Panel/actor

onready var PORTRAIT = $Panel/portrait

signal custom_signal(signal_)

var typing = false

func _ready():
	dialogue = DialogueFileManager.convert_json_to_dialogue(dialogue_path)
	start_conversation(dialogue)
	connect("custom_signal", self, "receive_signal")

func receive_signal(signal_):
	if signal_ == "test_signal":
		print("signal received")

func start_conversation(new_dialogue : Dictionary):
	for i in dialogue:
		if point in i:
			point = i
			break
	point = dialogue[point].next
	DialogueFileManager.emit_signal("conversation_started")
	execute_type()

#does the appropriate action based on what of a type of dialogie it is
func execute_type():
	if dialogue[point].type == "dialogue":
		#dialogue node
		write_line()
	elif dialogue[point].type == "choice":
		#choice
		display_choice()
	elif dialogue[point].type == "signal":
		emit_custom_signal()

func emit_custom_signal():
	print("emit custom signal: ", dialogue[point].content)
	
	emit_signal("custom_signal", dialogue[point].content)
	next_line()

func display_choice():
	for child in CHOICE_CONTAINER.get_children():
		child.queue_free()
	
	var index = 0
	for choice in dialogue[point].content:
		var button = Button.new()
		button.text = choice
		if dialogue[point].condition[index] != "":
			#dialogue has a condition
			var result = DialogueConditions.check_condition(dialogue[point].condition[index])
			if !result:
				if dialogue[point].hidden[index]:
					button.hide()
				else:
					button.disabled = true
				
		button.connect("pressed", self, "select_option", [index])
		CHOICE_CONTAINER.add_child(button)
		index += 1

func clear_choices():
	for i in CHOICE_CONTAINER.get_children():
		i.queue_free()

func select_option(index):
	print("choice selected")
	point = dialogue[point].next[index]
	clear_choices()
	if "EndNode"in point:
		end_conversation()
	else:
		execute_type()

func write_line():
	ACTOR_LABEL.text = DialogueFileManager.characters.get(str(dialogue[point].actor_index)).name
	
	var actor_color = DialogueFileManager.characters.get(str(dialogue[point].actor_index)).color
	ACTOR_LABEL.modulate = Color(actor_color[0],actor_color[1],actor_color[2])
	if dialogue[point].portrait != -1:
		PORTRAIT.texture = load(DialogueFileManager.characters.get(str(dialogue[point].actor_index)).portrait[dialogue[point].portrait])
	
	TEXTLABEL.bbcode_text = dialogue[point].content
	TEXTLABEL.percent_visible = 0
	typing = true
	TWEEN.interpolate_property(TEXTLABEL, "percent_visible", 0, 1.0, 1.5)
	TWEEN.start()
	yield(TWEEN, "tween_all_completed")
	typing = false
	#next_line()

func _input(event):
	if event.is_action_pressed("ui_accept") and dialogue[point].type == "dialogue":
		if typing:
			TWEEN.stop_all()
			TEXTLABEL.percent_visible = 1.0
			typing = false
		else:
			next_line()
	pass

func next_line():
	
	point = dialogue[point].next
	
	if "EndNode"in point:
		end_conversation()
	else:
		execute_type()

func end_conversation():
	var end_point = dialogue[point]
	print("dialogue ended")
	TWEEN.interpolate_property($Panel, "modulate:a", 1.0, 0.0, end_point.fade_out_spd)
	TWEEN.start()
	yield(get_tree().create_timer(5),"timeout")
	get_tree().quit()
