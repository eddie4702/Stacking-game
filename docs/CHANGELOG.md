# CHANGELOG
## Pancake Stacker

Record meaningful project changes here, newest first. Keep entries concise and factual.

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
