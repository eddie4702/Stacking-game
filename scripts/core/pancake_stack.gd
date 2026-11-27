class_name PancakeStack
extends Node2D
## Coordinates pancake spawning and placement progression.
##
## The base pancake is stationary and supports only the first moving pancake.
## After each successful placement, the placed pancake becomes the support and
## the next moving pancake inherits from it. This script performs no overlap
## maths and does not resize or reposition a pancake itself; it reuses
## PancakeOverlap.calculate() and Pancake.apply_overlap_result().

const PANCAKE_SCENE: PackedScene = preload("res://scenes/gameplay/pancake.tscn")

@onready var _base_pancake: Node2D = $Pancake
@onready var _gameplay_area: Control = $GameplayArea

var _support_pancake: Node2D
var _active_pancake: Node2D
var _active_movement: PancakeMovement
var _active_was_moving: bool = false


func _ready() -> void:
	# A fresh game always starts its first moving pancake on the left.
	PancakeMovement.reset_start_sequence()

	var base_movement := _base_pancake.get_node("Movement") as PancakeMovement
	base_movement.moving = false

	_support_pancake = _base_pancake
	_spawn_moving_pancake()


func _process(_delta: float) -> void:
	if _active_movement == null or not _active_was_moving:
		return
	if _active_movement.moving:
		return
	_finish_placement()


func _spawn_moving_pancake() -> void:
	var pancake: Node2D = PANCAKE_SCENE.instantiate()
	var movement := pancake.get_node("Movement") as PancakeMovement

	# Configure before entering the tree so autostart cannot consume a turn.
	movement.autostart = false
	movement.movement_area = _gameplay_area
	add_child(pancake)

	var inherited_width: float = float(_support_pancake.get("width"))
	var inherited_height: float = float(_support_pancake.get("height"))
	pancake.set("width", inherited_width)
	pancake.set("height", inherited_height)
	pancake.set("color", _support_pancake.get("color"))

	# Spawn at the support's absolute centre, one pancake height above it.
	# start() then applies the existing alternating starting-side behaviour.
	pancake.global_position = Vector2(
		_support_pancake.global_position.x,
		_support_pancake.global_position.y - (inherited_height + float(pancake.get("height"))) / 2.0
	)

	movement.start()
	_active_pancake = pancake
	_active_movement = movement
	_active_was_moving = movement.moving


func _finish_placement() -> void:
	var placed := _active_pancake
	var movement := _active_movement

	# Clear the active pancake first so repeated input cannot place it twice.
	_active_pancake = null
	_active_movement = null
	_active_was_moving = false

	if placed == null:
		return
	if movement != null:
		movement.moving = false

	var overlap_result: Dictionary = PancakeOverlap.calculate(
		placed.global_position.x,
		float(placed.get("width")),
		_support_pancake.global_position.x,
		float(_support_pancake.get("width"))
	)

	if overlap_result.get(PancakeOverlap.KEY_IS_COMPLETE_MISS, true) == true:
		return
	if not placed.call("apply_overlap_result", overlap_result):
		return

	_support_pancake = placed
	_spawn_moving_pancake()
