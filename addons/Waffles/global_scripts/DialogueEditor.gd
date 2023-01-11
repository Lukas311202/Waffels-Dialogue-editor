tool
extends Node


var NAMING_FIELD

func input_text():
	NAMING_FIELD.type_name()
	yield(NAMING_FIELD, "result_finished")
	return NAMING_FIELD.result

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
