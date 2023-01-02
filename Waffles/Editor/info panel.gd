tool
extends Panel

func show_save_icon():
	$Label2.text = "saved"
	$Label2.modulate = Color.green

func hide_save_icon():
	$Label2.text = "changes were made"
	$Label2.modulate = Color.red
