extends Node

func check_condition(condition) ->bool:
	var result = true
	
	if condition == "mystery":
		result = false
	
	return result
