extends Reference

# When you need your measurements in FREEDOM UNITS
static func metres_to_feet(p_metres: float) -> float:
	return p_metres * 3.2808

# What, FREEDOM isn't good enough for you?!
static func feet_to_metres(p_feet: float) -> float:
	return p_feet * 0.3048
