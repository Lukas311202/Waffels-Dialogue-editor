tool
extends Panel

var result
signal result_finished

func type_name():
	show()


func _on_LineEdit_text_entered(new_text):
	$LineEdit.text = new_text

func close():
	hide()

func cancel():
	close()
	result = ""
	emit_signal("result_finished")

func return_result():
	close()
	result = $LineEdit.text
	emit_signal("result_finished")
