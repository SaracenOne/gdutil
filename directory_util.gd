tool
extends Reference

enum directory_search_options {
	SEARCH_ALL_DIRS,
	SEARCH_LOCAL_DIR_ONLY
}

static func get_files_in_directory_path(p_path : String) -> Array:
	var files : Array = []
	var dir : Directory = Directory.new()
	if(dir.open(p_path) == OK):
		dir.list_dir_begin()
		
		while(true):
			var file : String = dir.get_next()
			if(file == ""):
				break
			elif not(file.begins_with(".")) and not(dir.current_is_dir()):
				files.append(file)
				
		dir.list_dir_end()
	return files

static func get_files(p_directory : Directory, current_dir_path : String, p_search_pattern : String, p_search_options : int) -> Array:
	p_directory.list_dir_begin()
	var current_file_name : String = ""
	var valid_files : Array = []
	current_file_name = p_directory.get_next()
	
	while(current_file_name.empty() == false):
		if(p_directory.current_is_dir()):
			if(current_file_name != "." and current_file_name != ".."):
				if(p_search_options == directory_search_options.SEARCH_ALL_DIRS):
					var sub_directory = Directory.new()
					if(sub_directory.open(current_file_name)):
						var appendable_files = get_files(sub_directory, current_dir_path + '/' + current_file_name, p_search_pattern, p_search_options)
						if(appendable_files != null):
							valid_files.append(appendable_files)
		else:
			if(p_directory.file_exists(current_dir_path + '/' + current_file_name) == true):
				valid_files.append(current_dir_path + '/' + current_file_name)
				
		current_file_name = p_directory.get_next()
		
	return valid_files
	
static func delete_dir_and_contents(p_directory : Directory, current_dir_path : String, p_delete_root : bool) -> int:
	p_directory.list_dir_begin()
	var current_file_name : String = ""
	var all_deleted : int = OK
	current_file_name = p_directory.get_next()
	
	while(current_file_name.empty() == false):
		if(p_directory.current_is_dir()):
			if(current_file_name != "." and current_file_name != ".."):
				var sub_directory : Directory = Directory.new()
				if(sub_directory.open(current_file_name)):
					if(delete_dir_and_contents(p_directory, current_dir_path + '/' + current_file_name, false) == FAILED):
							all_deleted = FAILED
					else:
						all_deleted = FAILED
		else:
			if(p_directory.file_exists(current_dir_path + '/' + current_file_name) == true):
				if(p_directory.remove(current_dir_path + '/' + current_file_name) == FAILED):
					all_deleted = FAILED
				
		current_file_name = p_directory.get_next()
		
	if(p_delete_root):
		if(all_deleted == OK):
			if(p_directory.remove(current_dir_path) == FAILED):
				all_deleted = FAILED
		
	return all_deleted
