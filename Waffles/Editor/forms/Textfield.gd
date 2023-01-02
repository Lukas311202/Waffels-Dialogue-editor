tool
extends HBoxContainer

var custom_field = false
var character_window : Control

func Load(key : String, data):
	$Label.text = key
	$LineEdit.text = data
	var txt_changed_function = "update_current_data" if !custom_field else "update_current_custom_data" 
	$LineEdit.connect("text_changed", character_window, txt_changed_function, [key]) 
