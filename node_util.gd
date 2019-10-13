extends Node

static func find_nodes_in_group(p_group : String, p_node : Node) -> Array:
	var valid_nodes : Array = Array()
	
	for group in p_node.get_groups():
		if p_group == group:
			valid_nodes.push_back(p_node)
	
	for child in p_node.get_children():
		var valid_child_nodes : Array = find_nodes_in_group(p_group, child)
		for valid_child_node in valid_child_nodes:
			valid_nodes.push_back(valid_child_node)
		
	return valid_nodes

static func spatial_calculate_global_transform(p_spatial : Spatial) -> Transform:
	var parent : Spatial = p_spatial.get_parent_spatial()
	if parent:
		return spatial_calculate_global_transform(parent) * p_spatial.transform
	else:
		return p_spatial.transform
		
