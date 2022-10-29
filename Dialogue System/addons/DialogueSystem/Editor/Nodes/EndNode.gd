tool
extends GraphNode

func save_node() -> Dictionary:
	var data = {
		"filename": filename,
		"rect_x": offset.x,
		"rect_y": offset.y,
		"size_x":rect_size.x,
		"size_y":rect_size.y,
		"name":name,
		"fade_out_spd": float($Control.text)
	}
	
	return data

func load_node(data : Dictionary):
	$Control.text = str(data.fade_out_spd)

