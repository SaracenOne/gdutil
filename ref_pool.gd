tool
extends Reference

# Stopgap, used until 4.0

var pool_byte_array: PoolByteArray = PoolByteArray()


func _init(p_pool_byte_array: PoolByteArray) -> void:
	pool_byte_array = p_pool_byte_array
