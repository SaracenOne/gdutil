tool

static func pool_byte_array_find(pool_byte_array : PoolByteArray, byte : int) -> int:
	for i in range(0, pool_byte_array.size()):
		if pool_byte_array[i] == byte:
			return i
			
	return -1

static func pool_int_array_find(pool_int_array : PoolIntArray, integer : int) -> int:
	for i in range(0, pool_int_array.size()):
		if pool_int_array[i] == integer:
			return i
		
	return -1
