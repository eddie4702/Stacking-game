class_name PancakeOverlap
extends RefCounted
## Deterministic horizontal overlap calculation for one pancake placement.
##
## Inputs are gameplay values only: each pancake's absolute centre X and its
## width in pixels. Nothing here reads scene nodes, the Visual ColorRect,
## physics or global state.
##
## Returned Dictionary keys:
## - "is_complete_miss": true when overlap_width <= 0.
## - "overlap_width": raw (overlap_right - overlap_left), so a separated pair
##   returns a negative value. Zero means the pancakes only touch at one edge.
## - "overlap_center_x": the overlap midpoint when an overlap exists, otherwise
##   null.

const KEY_IS_COMPLETE_MISS := "is_complete_miss"
const KEY_OVERLAP_WIDTH := "overlap_width"
const KEY_OVERLAP_CENTER_X := "overlap_center_x"


## Calculates the horizontal overlap between a stopped moving pancake and the
## supporting pancake directly beneath it.
static func calculate(
	moving_center_x: float,
	moving_width: float,
	support_center_x: float,
	support_width: float
) -> Dictionary:
	var moving_left: float = moving_center_x - moving_width / 2.0
	var moving_right: float = moving_center_x + moving_width / 2.0
	var support_left: float = support_center_x - support_width / 2.0
	var support_right: float = support_center_x + support_width / 2.0

	var overlap_left: float = maxf(moving_left, support_left)
	var overlap_right: float = minf(moving_right, support_right)
	var overlap_width: float = overlap_right - overlap_left
	var is_complete_miss: bool = overlap_width <= 0.0

	return {
		KEY_IS_COMPLETE_MISS: is_complete_miss,
		KEY_OVERLAP_WIDTH: overlap_width,
		KEY_OVERLAP_CENTER_X: null if is_complete_miss else (overlap_left + overlap_right) / 2.0,
	}
