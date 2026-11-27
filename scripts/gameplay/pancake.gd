@tool
extends Node2D
## One pancake placeholder.
##
## `width` and `height` are the pancake's dimensions in pixels. They are the
## values other code should read; the child `Visual` node only draws them.
## The node's origin is the centre of the pancake.
##
## This script contains no movement, input, stacking or scoring logic.

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


## Makes the Visual node match the current width, height and colour.
func _update_visual() -> void:
	# Setters can run before the scene is ready (for example while a scene is
	# loading); _ready() applies the values afterwards.
	if _visual == null:
		return
	_visual.size = Vector2(width, height)
	_visual.position = -_visual.size / 2.0
	_visual.color = color
