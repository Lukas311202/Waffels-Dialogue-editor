tool
extends HBoxContainer


var custom_field = false
var character_window : Control

func Load(key : String, data):
	$Label.text = key
	$LineEdit.text = data
	var txt_changed_function = "update_current_data" if !custom_field else "update_current_custom_data" 
	$LineEdit.connect("text_changed", character_window, txt_changed_function, [key]) 



func _on_TextureButton_pressed():
	print("open filedialog")
	get_parent().get_parent().get_parent().get_node("FileDialog").show()
	get_parent().get_parent().get_parent().get_node("FileDialog").connect("file_selected", self, "file_selected")

func file_selected(file):
	$LineEdit.text = file
	$LineEdit.emit_signal("text_changed", $LineEdit.text)
