extends Node

func check_condition(condition) ->bool:
	if condition == "mystery":
		return false
	if condition == "friends":
		return GlobalDialogue.current_speaker.pl_relation >= 50
	
	return true
