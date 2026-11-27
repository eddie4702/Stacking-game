# CHANGELOG
## Pancake Stacker

Record meaningful project changes here, newest first. Keep entries concise and factual.

---

## 2026-11-26 — TASK-003: Pancake movement (awaiting review)

- Added `scripts/gameplay/pancake_movement.gd` (plus its generated `.uid`) and a `Movement` child node in `scenes/gameplay/pancake.tscn`. `pancake.gd` is unchanged.
- The pancake moves horizontally within `GameplayArea` (exported `movement_area`) using its current width, reversing at the edges. Based on `delta`; no physics. Exports: `movement_area`, `speed` (250 px/s, provisional), `autostart`; plus a `moving` flag.
- Alternating start sides (extra requirement confirmed by the project owner): each pancake that starts moving takes the next side through a shared counter: left moving right, then right moving left, and so on. `reset_start_sequence()` restarts it; nothing calls it yet. This overlaps the scope of TASK-004, which was left unchanged for the owner to re-scope (a note was added to it).
- `scenes/main/main.tscn`: wired `Movement.movement_area` to `GameplayArea` (editable children). Removed the instance's `width = 600.0` override, which was as wide as the whole area, so the pancake had no room to move; the default width 300 applies. Restore it if it was deliberate.
- Automated tests (Godot 4.7-stable, headless): syntax check, import, project run and editor-mode load all clean. A 59-check script stepping the movement by hand passed, covering the 10 test items: start side and direction, reversal at both edges, alternation over 10 pancakes, staying inside the area for many widths with random frame times, identical results at 10 to 1000 fps and for one huge step, width changes while moving, independent pancakes, offset parents, and no input/stacking/scoring code. Breaking the script six different ways made the tests fail each time (two gaps found and closed this way). The real main scene was also run with Godot's own frame loop at 20, 30, 60, 144 and 240 fps: every frame matched the expected position for the real elapsed time (max error 0.005 px) and both reversals happened at the boundaries. Screenshots were inspected.
- Not verified: running the game in the Godot editor, the `Movement` Inspector properties, a real GPU, a browser, a mobile device.
- Notes: under `--fixed-fps` Godot delivers irregular frame times for the first frames, so tests compared against the real deltas. A pancake exactly as wide as the area (or wider) stays centred and does not move.
- Not implemented: input, dropping, stacking, overlap, cutting, scoring, difficulty, camera, game over or restart, physics, art. TASK-004 has not been started.

---

## 2026-11-26 — TASK-002: Reusable pancake scene (awaiting review)

- Added `scenes/gameplay/pancake.tscn` and `scripts/gameplay/pancake.gd` (plus Godot's generated `pancake.gd.uid`): a `Pancake` Node2D with a `Visual` ColorRect child. Exported `width`, `height` (px) and `color`; `@tool` so the editor shows changes. Origin is the pancake's centre. Defaults 300x40 are placeholders.
- Instanced one static pancake in `scenes/main/main.tscn` at (360, 640). No other change to the main scene. `project.godot` is unchanged.
- TASKS.md: TASK-002 set to REVIEW; TASK-001 set to DONE (accepted and merged by the project owner).
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
