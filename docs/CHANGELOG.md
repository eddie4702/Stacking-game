# CHANGELOG
## Pancake Stacker

Record meaningful project changes here, newest first. Keep entries concise and factual.

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
