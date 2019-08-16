static func string_ends_with(p_main_string : String, p_end_string : String) -> bool:
	var pos : int = p_main_string.find_last(p_end_string)
	if (pos==-1):
		return false;
	return pos+p_end_string.length() == p_main_string.length();

static func teststr(p_what : String, p_str : String) -> bool:
	if(p_what.findn("$"+p_str)!=-1):
		return true
	if(string_ends_with(p_what.to_lower(), "-" + p_str)):
		return true
	if (string_ends_with(p_what.to_lower(), "_" + p_str)):
		return true
	return false

static func fixstr(p_what : String, p_str : String) -> String:
	if(p_what.findn("$" + p_str) != -1):
		return p_what.replace("$" + p_str, "")
	if(p_what.to_lower().ends_with("-" + p_str)):
		return p_what.substr(0,p_what.length()-(p_str.length() + 1))
	if(p_what.to_lower().ends_with("_" + p_str)):
		return p_what.substr(0,p_what.length()-(p_str.length() + 1))
	return p_what
