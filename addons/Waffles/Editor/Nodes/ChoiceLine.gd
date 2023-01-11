tool
extends HBoxContainer



func _on_hiddenCheckBox_pressed():
	$conditionedit.visible = $hiddenCheckBox.pressed
