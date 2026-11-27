extends SceneTree
## Focused regression test for malformed apply_overlap_result() input.

func _initialize() -> void:
	var scene: PackedScene = load("res://scenes/gameplay/pancake.tscn")
	var pancake: Node2D = scene.instantiate()

	# Keep the test deterministic: no automatic movement and no movement area.
	pancake.get_node("Movement").set("autostart", false)
	root.add_child(pancake)

	pancake.set("width", 220.0)
	pancake.set("height", 36.0)
	pancake.position = Vector2(123.0, 45.0)

	var before := _snapshot(pancake)
	var malformed_result := {
		PancakeOverlap.KEY_IS_COMPLETE_MISS: "false",
		PancakeOverlap.KEY_OVERLAP_WIDTH: 120.0,
		PancakeOverlap.KEY_OVERLAP_CENTER_X: 250.0,
	}

	var accepted: bool = pancake.call("apply_overlap_result", malformed_result)
	var after := _snapshot(pancake)

	if accepted:
		push_error("FAIL: malformed string is_complete_miss was accepted")
		quit(1)
		return

	if before != after:
		push_error("FAIL: pancake changed for malformed result; before=%s after=%s" % [before, after])
		quit(1)
		return

	print("PASS: malformed is_complete_miss rejected; pancake unchanged")
	quit(0)


func _snapshot(pancake: Node2D) -> Dictionary:
	var visual := pancake.get_node("Visual") as ColorRect
	var movement := pancake.get_node("Movement")
	return {
		"width": pancake.get("width"),
		"height": pancake.get("height"),
		"color": pancake.get("color"),
		"position": pancake.position,
		"global_position": pancake.global_position,
		"visual_size": visual.size,
		"visual_position": visual.position,
		"visual_color": visual.color,
		"movement_moving": movement.get("moving"),
	}
