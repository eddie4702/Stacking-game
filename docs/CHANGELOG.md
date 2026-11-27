# CHANGELOG
## Pancake Stacker

Record meaningful project changes here, newest first. Keep entries concise and factual.

---

## 2026-11-27 — TASK-008: Spawn the next pancake (merged)

- Added `scripts/core/pancake_stack.gd` (plus its generated `.uid`) and attached it to `Main`. The existing `Pancake` instance in `main.tscn` is now the stationary base via `Movement.autostart = false`. `pancake_movement.gd` gained `class_name PancakeMovement` so the controller can use the movement type and reset the shared start-side counter on fresh game setup.
- The controller spawns one moving pancake from the base, watches the active `Movement.moving` state change to `false`, calls `PancakeOverlap.calculate()` against the current support, applies a successful result with `apply_overlap_result()`, promotes that pancake to support, and spawns exactly one successor. Successors inherit width, height, colour and absolute centre from the immediately preceding placed pancake; a complete miss stops and spawns nothing.
- Each successor is spawned at the support's absolute centre, one pancake height above it. `Movement.start()` then applies the existing alternating starting-side behaviour, so spawn inheritance and side alternation are both preserved. No overlap mathematics, input handling, visuals, scoring, game-over, restart, camera or difficulty logic was duplicated or added.
- Automated tests (Godot 4.7.2-stable, headless): syntax checks, project import and a main-scene run were clean. A temporary 49-check harness passed: pre-start inheritance of width/centre/height, three consecutive placements (150 @ 125, 125 @ 112.5, 122.5 @ 111.25), immediate-support promotion, exactly one successor per placement, alternating left/right start sides, one moving pancake at a time, stationary placed pancakes, and no spawn after a complete miss. The harness emitted one expected warning from a probe with no movement area and was deleted afterwards.
- Documentation: TASK-008 marked REVIEW; technical design records the controller, stationary base and progression rules. TASK-009 and later tasks remain PLANNED and are not authorized.
- Not verified: real mouse/touch play, editor/GPU visuals, browser and mobile builds.

---

## 2026-11-27 — TASK-007: Apply the pancake overlap result (merged)

- Added `apply_overlap_result(result: Dictionary) -> bool` to `scripts/gameplay/pancake.gd`. For a successful `PancakeOverlap.calculate()` result it sets the pancake's actual `width` to `overlap_width` and its `global_position.x` to the absolute `overlap_center_x`; the existing width setter updates `Visual`. It returns `false` and changes nothing for a complete miss, invalid types, or non-positive width.
- No scene, movement, input, project-setting or visual-node changes. `y`, `height`, `color`, spawning, scoring, perfect-placement detection, game-over, camera and physics remain untouched. Callers must stop movement before applying a result; TASK-004 already does this.
- Automated tests (Godot 4.7.2-stable, headless): syntax check, project import and project run clean. A temporary 62-check harness passed, covering case A (right overhang: width 150, absolute centre 125), case B (left overhang: width 150, absolute centre 75), case C (repeated placement relative to the first placed pancake: width 125, absolute centre 112.5), visual size and centring, an unchanged complete miss, and an invalid non-miss result. A separate 7-check offset-parent harness confirmed that `global_position.x` receives the absolute centre while the local root X stays parent-relative. A mutation forcing root X to `0` caused 7 expected failures and was reverted. The temporary harnesses and their generated `.uid` files were deleted.
- Documentation: TASK-007 marked REVIEW; technical design records the actual application method and coordinate handling. TASK-008 remains PLANNED and is not authorized.
- Not verified: real editor/GPU visuals, manual mouse/touch play, browser and mobile builds. No stacking manager, base pancake, spawning, scoring or game-over logic was added.

---

## 2026-11-27 — Documentation clarification: stacking coordinates and inheritance

- Clarified in `game_design.md` and `docs/TECHNICAL_DESIGN.md` that a stationary, configurable base pancake supports the first moving pancake; the player never moves or places it.
- Documented that only the overlapping portion survives, with width equal to `overlap_width` and absolute centre in the shared gameplay coordinate system equal to `overlap_center_x = overlap_left + overlap_width / 2`. The Node2D root uses this absolute centre and the visual remains centred around it.
- Recorded the base example (edges `X = 0..200`, centre `X = 100`; overlap `X = 50..200` gives width `150`, midpoint offset from the surviving pancake's left edge `75`, absolute centre `X = 125`) and the rule that the next moving pancake inherits width `150` and uses the placed pancake at `X = 125` as support, not the base at `X = 100`.
- Clarified in `docs/TASKS.md` that TASK-007 applies the cut result (actual width, absolute centre and visual alignment) while TASK-008 spawns the next pancake with width and support reference inherited from the most recently placed pancake. No task IDs were created or renumbered.
- Documentation only: no GDScript, scenes, resources, project settings or gameplay behaviour were changed. No new gameplay functionality is implemented by this clarification.

---

## 2026-11-27 — TASK-005: Pancake overlap calculation (merged)

- Added `scripts/gameplay/pancake_overlap.gd` (plus Godot's generated `.uid`): a `RefCounted` utility with one static `calculate(moving_center_x, moving_width, support_center_x, support_width)` function. It uses only gameplay centre positions and widths; it does not read scene nodes, the `Visual` ColorRect, physics or global state.
- Result format is a three-key Dictionary: `is_complete_miss` (`true` when overlap width <= 0), raw signed `overlap_width` (negative when separated, zero when touching), and `overlap_center_x` (midpoint when overlapping, otherwise `null`).
- No scene, node, project-setting, movement, input or visual changes. No cutting, spawning, scoring, perfect-placement tolerance, game-over, camera or physics code was added.
- Automated tests (Godot 4.7.2-stable, headless): syntax check, import and project run clean. A temporary 63-check harness verified all nine required cases with exact numbers: exact alignment (300 @ 360), left overhang (240 @ 330), right overhang (240 @ 390), moving fully inside support (100 @ 400), moving fully covering support (300 @ 360), edge touch (0, miss), separation (-30, miss), cut/offset support (140 @ 430), and differing widths/centres (170 @ 385). A mutation replacing `maxf` with `minf` caused failures and was reverted. The temporary harness and its generated `.uid` were deleted.
- Documentation: TASK-005 marked REVIEW and updated to the calculation-only scope; technical design records the implementation and result format. TASK-007 and TASK-008 remain unauthorised.

---

## 2026-11-27 — TASK-004: Pancake placement input (approved, awaiting commit)

- Added a small `_input()` handler to `scripts/gameplay/pancake_movement.gd`. A left mouse press or the first touch press clears `moving` and stops the pancake at its current position; the handler never changes the position. It acts only while the pancake is moving, and ignores mouse release, right clicks, secondary touches and input while stopped.
- No scene structure change was needed: `Movement` already owns `moving` and is separate from `Visual`. No input manager, global system, signal or new node was added. `pancake.gd`, `pancake.tscn`, `main.tscn` and `project.godot` are unchanged.
- Alternating starting sides was already implemented in TASK-003 and was not implemented again.
- Automated tests (Godot 4.7.2-stable, headless): syntax check, project import and project run all clean. A temporary 25-check harness passed, covering stop on left click and first touch, exact position preservation, no movement after stopping, repeated/wrong input being ignored, no effect before movement starts, movement still advancing, and real engine-dispatched mouse and touch events. A mutation that removed the left-button check made two checks fail as expected; it was reverted. The temporary harness was deleted.
- Documentation: TASK-004 marked DONE after approval and re-scoped to placement input; TASK-005 redefined as stacking/overlap calculation; the redundant former TASK-006 overlap entry was merged into TASK-005; later task numbers retained. Technical design updated with the actual input implementation.
- Not verified: clicking/tapping in the Godot editor UI or a real running window, a real touchscreen, a browser build, a mobile device, and a real GPU. No stacking, overlap, cutting, spawning, scoring, difficulty, camera or game-over code was added.

---

## 2026-11-26 — TASK-003: Pancake movement (approved and merged)

- Status: approved by the project owner and merged into `main`.
- Added `scripts/gameplay/pancake_movement.gd` (plus its generated `.uid`) and a `Movement` child node in `scenes/gameplay/pancake.tscn`. `pancake.gd` is unchanged.
- The pancake moves horizontally within `GameplayArea` (exported `movement_area`) using its current width, reversing at the edges. Based on `delta`; no physics. Exports: `movement_area`, `speed` (250 px/s, provisional), `autostart`; plus a `moving` flag.
- Alternating start sides (extra requirement confirmed by the project owner): each pancake that starts moving takes the next side through a shared counter: left moving right, then right moving left, and so on. `reset_start_sequence()` restarts it; nothing calls it yet. This overlaps the scope of TASK-004, which was left unchanged for the owner to re-scope (a note was added to it).
- `scenes/main/main.tscn`: wired `Movement.movement_area` to `GameplayArea` (editable children). Removed the instance's `width = 600.0` override, which was as wide as the whole area, so the pancake had no room to move; the default width 300 applies. Restore it if it was deliberate.
- Automated tests (Godot 4.7-stable, headless): syntax check, import, project run and editor-mode load all clean. A 59-check script stepping the movement by hand passed, covering the 10 test items: start side and direction, reversal at both edges, alternation over 10 pancakes, staying inside the area for many widths with random frame times, identical results at 10 to 1000 fps and for one huge step, width changes while moving, independent pancakes, offset parents, and no input/stacking/scoring code. Breaking the script six different ways made the tests fail each time (two gaps found and closed this way). The real main scene was also run with Godot's own frame loop at 20, 30, 60, 144 and 240 fps: every frame matched the expected position for the real elapsed time (max error 0.005 px) and both reversals happened at the boundaries. Screenshots were inspected.
- Not verified: running the game in the Godot editor, the `Movement` Inspector properties, a real GPU, a browser, a mobile device.
- Notes: under `--fixed-fps` Godot delivers irregular frame times for the first frames, so tests compared against the real deltas. A pancake exactly as wide as the area (or wider) stays centred and does not move.
- Not implemented: input, dropping, stacking, overlap, cutting, scoring, difficulty, camera, game over or restart, physics, art. TASK-004 has not been started.

---

## 2026-11-26 — TASK-002: Reusable pancake scene (approved and merged)

- Status: approved by the project owner and merged into `main`.
- Added `scenes/gameplay/pancake.tscn` and `scripts/gameplay/pancake.gd` (plus Godot's generated `pancake.gd.uid`): a `Pancake` Node2D with a `Visual` ColorRect child. Exported `width`, `height` (px) and `color`; `@tool` so the editor shows changes. Origin is the pancake's centre. Defaults 300x40 are placeholders.
- Instanced one static pancake in `scenes/main/main.tscn` at (360, 640). No other change to the main scene. `project.godot` is unchanged.
- TASKS.md: TASK-002 set to DONE after approval and merge; TASK-001 set to DONE (accepted and merged by the project owner).
- Automated tests (Godot 4.7-stable, headless): syntax check, import, project run and editor-mode load all clean; a 31-check script covering defaults, runtime changes, values set before entering the tree, independent instances, invalid values, absence of processing/input/signals, and the main-scene instance passed. A software-rendered screenshot was inspected.
- Not verified: Inspector editing and live editor preview, a real GPU, a browser, a mobile device.
- Notes: `GameplayArea` (TASK-001) uses a default ColorRect mouse filter; check when TASK-005 handles input that it does not block clicks (not verified either way).
- No movement, input, stacking, overlap, cutting, scoring, difficulty, camera, physics or game-state features were implemented. TASK-003 has not been started.

---

## 2026-11-26 — Future visual direction recorded (documentation only)

- Recorded a possible long-term 2.5D presentation as a future direction. The prototype and gameplay remain 2D; no migration to 3D and no 2.5D implementation.
- Documented that gameplay calculations use gameplay coordinates and dimensions, independent of visual representation.
- Updated `game_design.md` (now v0.3), `docs/TECHNICAL_DESIGN.md` and `docs/TASKS.md` (later milestones only; no new authorized task).
- No gameplay mechanics, project settings or scenes were changed.

---

## 2026-11-26 — TASK-001: Godot project foundation (awaiting review)

- Configured `project.godot`: 720x1280 portrait viewport, portrait orientation, 405x720 desktop window override, main scene set to `res://scenes/main/main.tscn`.
- Added `scenes/main/main.tscn`: `Main` (Node2D) with a full-screen placeholder background (`Background` CanvasLayer + `BackgroundColor`) and a placeholder `GameplayArea` rectangle (600x960 at 60,160).
- Existing stretch settings, renderer, icon and project name were left unchanged.
- Tested with Godot 4.7-stable: import and headless run clean, no errors or warnings; screenshots inspected at several window sizes via software rendering. Not tested on a GPU, in a browser or on a mobile device.
- Known issues: stretch aspect `expand` leaves the gameplay area at the top-left on non-9:16 windows; the Mobile renderer may not suit the Web target; project name is `PancakeStack`. All left for owner decision.
- No gameplay was implemented. TASK-002 has not been started.

---

## 2026-11-26 — Documentation starter set

- Prepared GDD version 0.2.
- Clarified camera requirement: follow the height of the current stacking object.
- Established AI collaboration rules for sequential Claude and WorkBuddy development.
- Created an incremental development roadmap.
- Only TASK-001 (Godot project foundation) is initially authorized.
- No game implementation has been performed by this documentation package.
