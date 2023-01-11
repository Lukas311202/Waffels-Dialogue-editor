extends TextureButton



func _on_present_pressed():
	get_parent().get_node("player_inventory").select_item_from_inventory()
