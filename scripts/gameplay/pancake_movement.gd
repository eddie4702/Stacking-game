extends Node
## Moves the parent Pancake back and forth across the gameplay area.
##
## The left and right limits come from `movement_area` (the GameplayArea). The
## pancake's actual `width` is used, so the whole pancake stays inside the area,
## not only its centre. This script only changes the pancake's horizontal
## position. It never touches the Visual node, and it contains no stacking,
## scoring, difficulty or camera logic. Its only input handling is stopping
## itself on a click or tap.
##
## Alternating start sides: each pancake that starts moving takes the next side
## in the sequence left, right, left, right, ... (see start()).

## The area the pancake moves within (normally the GameplayArea node).
@export var movement_area: Control

## Movement speed in pixels per second.
## PROVISIONAL: a temporary default, not a final game-design decision.
@export_range(0.0, 2000.0, 1.0, "or_greater", "suffix:px/s") var speed: float = 250.0

## If true, the pancake starts moving as soon as it is ready. Set it to false
## to place a pancake without it moving or taking a turn in the start sequence.
@export var autostart: bool = true

## True while the pancake is moving. Set it to false to stop the pancake where
## it is. start() sets it to true.
var moving: bool = false

# How many pancakes have started moving. Shared by all pancakes, and decides
# which side the next one starts on.
static var _started_count: int = 0

# 1.0 = moving right, -1.0 = moving left.
var _direction: float = 1.0

@onready var _pancake: Node2D = get_parent()


## Restarts the start-side sequence, so the next pancake to start begins on the
## left. Nothing calls this yet; it is needed when a run restarts.
static func reset_start_sequence() -> void:
	_started_count = 0


func _ready() -> void:
	if autostart:
		start()


## A left click or a tap stops the pancake in place. The position is left
## untouched; _process() simply stops advancing it on the next frame.
func _input(event: InputEvent) -> void:
	# Ignore input unless this pancake is actually moving. This also makes a
	# second event from the same press harmless (for example mouse emulation).
	if not moving:
		return

	var mouse_event := event as InputEventMouseButton
	if mouse_event != null:
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			moving = false
		return

	var touch_event := event as InputEventScreenTouch
	if touch_event != null and touch_event.pressed and touch_event.index == 0:
		moving = false


## Puts the pancake on the next starting side and starts it moving. The first
## pancake starts on the left and moves right, the second starts on the right
## and moves left, and so on.
func start() -> void:
	if movement_area == null:
		push_warning("PancakeMovement: movement_area is not set, so the pancake cannot move.")
		return
	var starts_on_left: bool = _started_count % 2 == 0
	_started_count += 1
	var limits := _get_limits()
	_direction = 1.0 if starts_on_left else -1.0
	_pancake.global_position.x = limits.x if starts_on_left else limits.y
	moving = true


func _process(delta: float) -> void:
	if not moving or movement_area == null:
		return

	var limits := _get_limits()
	var travel_range := limits.y - limits.x
	if travel_range <= 0.0:
		# The pancake is as wide as the area (or wider): there is no room to move.
		_pancake.global_position.x = limits.x
		return

	# If the width grew since the last frame, bring the pancake back inside first.
	var current_x := clampf(_pancake.global_position.x, limits.x, limits.y)

	# Move by speed * delta, then "fold" the result back between the limits, as
	# if the pancake bounced off them. Folding (instead of reversing once per
	# frame) keeps the movement exact at any frame rate and for any delta.
	var unfolded := (current_x - limits.x) + _direction * maxf(speed, 0.0) * delta
	var period := 2.0 * travel_range
	var folded := fposmod(unfolded, period)
	if folded > travel_range:
		# This frame ended on the "way back" half of a bounce: direction reversed.
		folded = period - folded
		_direction = -_direction
	_pancake.global_position.x = limits.x + folded


## The leftmost and rightmost x positions of the pancake's centre, in global
## coordinates. If the pancake is wider than the area, both are the area's centre.
func _get_limits() -> Vector2:
	var area_rect := movement_area.get_global_rect()
	var half_width: float = _pancake.width / 2.0
	var left := area_rect.position.x + half_width
	var right := area_rect.end.x - half_width
	if left > right:
		left = area_rect.get_center().x
		right = left
	return Vector2(left, right)
