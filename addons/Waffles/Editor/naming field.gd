tool
extends Panel
class_name TextInput

var result
signal result_finished

func _ready():
	DialogueEditor.NAMING_FIELD = self

func type_name():
	show()
	$LineEdit.text = ""


func _on_LineEdit_text_entered(new_text):
	$LineEdit.text = new_text

func close():
	hide()

func cancel():
	close()
	result = FAILED
	emit_signal("result_finished")

func return_result():
	close()
	result = $LineEdit.text
	emit_signal("result_finished")
