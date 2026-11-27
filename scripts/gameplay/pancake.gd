@tool
extends Node2D
## One pancake placeholder.
##
## `width` and `height` are the pancake's dimensions in pixels. They are the
## values other code should read; the child `Visual` node only draws them.
## The node's origin is the centre of the pancake.
##
## This script contains no movement, input or scoring logic. It can apply a
## supplied overlap result, but it does not calculate overlap or manage a stack.

@export_range(0.0, 720.0, 1.0, "or_greater", "suffix:px") var width: float = 300.0:
	set(value):
		width = maxf(value, 0.0)
		_update_visual()

@export_range(0.0, 200.0, 1.0, "or_greater", "suffix:px") var height: float = 40.0:
	set(value):
		height = maxf(value, 0.0)
		_update_visual()

@export var color: Color = Color(0.93, 0.7, 0.33, 1.0):
	set(value):
		color = value
		_update_visual()

@onready var _visual: ColorRect = $Visual


func _ready() -> void:
	_update_visual()


## Applies a successful result from PancakeOverlap.calculate() to this pancake.
##
## `overlap_center_x` is an absolute gameplay X coordinate, so it is assigned to
## global_position.x. The existing width setter updates the Visual node; this
## method does not touch Visual, height, colour, y or Movement. The caller is
## responsible for stopping movement before applying a result.
##
## Returns false and changes nothing for a complete miss or an invalid result.
func apply_overlap_result(result: Dictionary) -> bool:
	var is_complete_miss = result.get(PancakeOverlap.KEY_IS_COMPLETE_MISS, true)
	if typeof(is_complete_miss) != TYPE_BOOL:
		return false
	if is_complete_miss == true:
		return false

	var width_value = result.get(PancakeOverlap.KEY_OVERLAP_WIDTH)
	var center_value = result.get(PancakeOverlap.KEY_OVERLAP_CENTER_X)
	if typeof(width_value) != TYPE_FLOAT and typeof(width_value) != TYPE_INT:
		return false
	if typeof(center_value) != TYPE_FLOAT and typeof(center_value) != TYPE_INT:
		return false

	var new_width: float = float(width_value)
	var new_center_x: float = float(center_value)
	if new_width <= 0.0:
		return false

	width = new_width
	global_position.x = new_center_x
	return true


## Makes the Visual node match the current width, height and colour.
func _update_visual() -> void:
	# Setters can run before the scene is ready (for example while a scene is
	# loading); _ready() applies the values afterwards.
	if _visual == null:
		return
	_visual.size = Vector2(width, height)
	_visual.position = -_visual.size / 2.0
	_visual.color = color
