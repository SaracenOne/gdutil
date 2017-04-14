extends Node
tool

static func get_string_for_integer_with_group_seperator(p_integer, p_seperator, p_grouping_size):
	var formatted_string = str(p_integer)
	var formatted_string_length = formatted_string.length()
	var grouping_counter = 0
	
	var idx = formatted_string_length-1
	while(idx > 0):
		grouping_counter += 1
		if grouping_counter == p_grouping_size:
			formatted_string = formatted_string.insert(idx, p_seperator)
			grouping_counter = 0
		idx -= 1
	
	return formatted_string