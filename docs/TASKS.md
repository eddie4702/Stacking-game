# DEVELOPMENT TASKS
## Pancake Stacker

**Version:** 0.1  
**Status key:** `READY` = may be assigned; `PLANNED` = not yet authorized; `IN PROGRESS` = currently being worked on; `REVIEW` = awaiting owner review; `DONE` = accepted and tested.

> Important: This is the roadmap, not blanket permission to implement everything. Only tasks explicitly authorized by the project owner may be started; the current authorization is stated at the end of this file.

---

## Milestone 1 — Project foundation

### TASK-001 — Create the Godot project foundation
**Status:** DONE

**Goal:** Create a minimal, runnable Godot 4 project with a portrait-oriented main scene and a clean initial directory structure.

**Scope:**
- Inspect the repository and existing files first.
- Create or configure the Godot project.
- Configure portrait orientation and a sensible initial viewport.
- Create a main scene.
- Add a simple placeholder background and clearly defined gameplay area.
- Create only the folders needed for the initial project.
- Ensure the project launches.

**Out of scope:**
- Pancake behavior or movement.
- Input handling.
- Stacking or overlap calculations.
- Scoring.
- Camera-follow behavior.
- Game-over or restart logic.
- Final artwork, audio or monetization.

**Acceptance criteria:**
- Project opens in the target Godot 4 version.
- Main scene runs without errors.
- Portrait layout is visible and usable.
- Initial folder structure is clear.
- No future gameplay systems have been prematurely implemented.

**Deliverable:** A runnable project foundation and a report of files created and tests performed.

**Result (2026-11-26):** Reviewed and tested in the Godot editor by the project owner, then merged into `main`.
- `project.godot` configured: 720x1280 portrait viewport, portrait handheld orientation, 405x720 desktop window override, main scene set. Existing stretch settings (`canvas_items` / `expand`) left unchanged.
- `scenes/main/main.tscn` created: solid placeholder background plus a placeholder gameplay area. No scripts.
- Claude tested with Godot 4.7-stable: project imports and runs headless with no errors or warnings; a software-rendered screenshot was inspected at several window sizes. Claude did not test on a real GPU, in the Godot editor UI, in a browser, or on a mobile device.
- Known issues and items to verify manually are listed in the TASK-001 completion report and in `docs/CHANGELOG.md`.

### TASK-002 — Create a reusable pancake scene
**Status:** DONE

**Goal:** Create one simple reusable pancake placeholder scene.

**Scope:**
- Represent a pancake with a simple visual shape.
- Expose or clearly define its dimensions.
- Make it instantiable by another scene or script.
- Keep it free of movement, stacking and scoring behavior unless explicitly needed for the scene itself.

**Acceptance criteria:**
- Pancake scene can be instanced in the main scene.
- Its visual dimensions are easy to inspect and adjust.
- No unrelated gameplay logic is included.

**Result (2026-11-26):** Reviewed and tested in the Godot editor by the project owner, then merged into `main`.
- `scenes/gameplay/pancake.tscn` created: `Pancake` (Node2D, script `scripts/gameplay/pancake.gd`) with one child, `Visual` (ColorRect).
- `width`, `height` (pixels) and `color` are exported, so they can be set in the Inspector or from code. The script is `@tool`, so the scene also updates in the editor. Negative sizes are clamped to 0.
- The node's origin is the centre of the pancake. Defaults are 300x40 and a golden colour; these are placeholders, not design decisions (GDD section 16, item 1 is still undecided).
- One default pancake is instanced in `scenes/main/main.tscn` at (360, 640) as a static placeholder.
- No movement, input, stacking, overlap, cutting, scoring, difficulty, camera, physics or game-state code.
- Automated tests with Godot 4.7-stable passed (see `docs/CHANGELOG.md`). Still to verify manually in the Godot editor: Inspector editing and live preview of `width`, `height` and `color`.

---

## Milestone 2 — Movement and input

### TASK-003 — Implement horizontal pancake movement
**Status:** DONE

**Goal:** Move one pancake smoothly from side to side within defined horizontal boundaries.

**Scope:**
- Implement configurable movement speed.
- Reverse direction at the movement boundaries.
- Account for pancake width when determining boundaries.
- Keep movement independent from stacking calculations.

**Acceptance criteria:**
- Pancake moves continuously between boundaries.
- It does not move outside the permitted horizontal area.
- Direction reversal is reliable.
- Movement speed can be adjusted without editing core logic.

**Result (2026-11-26):** Reviewed and tested in the Godot editor by the project owner, then merged into `main`.
- `scripts/gameplay/pancake_movement.gd` created and added as a `Movement` child node in `scenes/gameplay/pancake.tscn`. `pancake.gd` is unchanged.
- The pancake moves back and forth within `GameplayArea` (set through the exported `movement_area`), using its current `width` so the whole pancake stays inside, and reverses at the edges. Movement uses `delta`; no physics.
- `speed` is exported: 250 px/s. This is a provisional default, not a final design decision (GDD section 16, items 2 to 4 are still undecided).
- Alternating start sides, an extra requirement confirmed by the project owner for this task: the first pancake starts on the left and moves right, the second starts on the right and moves left, and so on. TASK-004 was subsequently re-scoped to placement input, so alternation is not part of TASK-004.
- `scenes/main/main.tscn`: `Movement` is wired to `GameplayArea`. The instance's `width = 600.0` override (as wide as the whole area, so no room to move) was removed; the default 300 applies.
- Automated tests with Godot 4.7-stable passed (see `docs/CHANGELOG.md`). Still to verify manually in the Godot editor: running the game and watching the pancake, and the `Movement` node's Inspector properties on the main-scene instance.

### TASK-004 — Implement pancake placement input
**Status:** DONE

**Goal:** Let the player stop the currently moving pancake at its current horizontal position with one tap or click.

**Scope:**
- Support left mouse clicks on desktop/web.
- Support touchscreen taps on mobile.
- Stop the active pancake by clearing the movement system's `moving` state; do not add a second movement implementation.
- Preserve the pancake's exact position at the moment of input.
- Ignore repeat events from one press and input while the pancake is not moving.

**Acceptance criteria:**
- A moving pancake stops when clicked with the left mouse button.
- A moving pancake stops when tapped on a touchscreen.
- The pancake remains at its stopped position and does not move afterwards.
- Input before the pancake starts moving has no effect.
- Repeated clicks or taps do not cause unexpected behaviour.
- The existing movement system still works.

**Result (2026-11-27):** Implemented and approved by the project owner; awaiting commit/merge.
- `scripts/gameplay/pancake_movement.gd` gained a small `_input()` handler. It responds only to a left mouse press or the first touch press, and only while `moving` is true. It clears `moving` and changes no position.
- No new scene nodes, input managers or global systems were added; `pancake.gd`, `pancake.tscn`, `main.tscn` and `project.godot` are unchanged. The existing `Movement` node already owns `moving` and is separate from `Visual`, so the scene structure did not need modification.
- Alternating starting sides was already implemented in TASK-003. It was not implemented again and is no longer part of TASK-004.
- Automated tests with Godot 4.7.2-stable passed (25 checks; see `docs/CHANGELOG.md`). Still to verify manually: real mouse clicks and real touchscreen taps in the running/editor game, a browser build, and a mobile device.

---

## Milestone 3 — Stacking

> Roadmap note (2026-11-27): the former TASK-006 overlap task was merged into TASK-005. Later task numbers are retained to avoid rewriting existing IDs. TASK-007 remains the separate overhang-application task if cutting is not folded into TASK-005.

### TASK-005 — Implement Pancake Overlap Calculation
**Status:** REVIEW

**Goal:** Deterministically calculate the horizontal overlap between the pancake the player has just stopped and the supporting pancake directly beneath it.

**Scope:**
- Use centre-based gameplay coordinates and actual widths; do not read visual node sizes.
- Provide a small, independently testable static calculation.
- Return a complete-miss flag, the calculated overlap width and the overlap centre X when an overlap exists.
- Handle support pancakes that are already narrower and offset from the original base centre.

**Acceptance criteria:**
- Exact alignment, left overhang, right overhang, fully inside, fully covering, edge touch, separation, cut/offset support, and differing widths/centres all produce verified numerical results.
- Complete misses are detected when `overlap_width <= 0`, without game-over logic.
- No pancake nodes are resized or repositioned; no visuals, spawning, scoring, perfect tolerance or physics are added.
- No duplicate placement input is added; TASK-004 already provides it.

**Dependencies:** TASK-004 supplies the stopped pancake. Applying the calculation to pancake dimensions remains TASK-007.

**Result (2026-11-27):** Implemented and awaiting owner review.
- `scripts/gameplay/pancake_overlap.gd` (plus Godot's generated `.uid`) added: a `RefCounted` utility with one static `calculate()` function and a three-key Dictionary result. No scene, node or project-setting changes.
- The returned Dictionary contains `is_complete_miss`, raw signed `overlap_width`, and `overlap_center_x` (midpoint or `null` on a complete miss).
- Automated tests with Godot 4.7.2-stable passed: syntax check, import, project run and a temporary 63-check harness covering all nine required edge cases with exact expected values. A mutation replacing `maxf` with `minf` produced failures and was reverted. The temporary harness was deleted.
- Not implemented: applying the cut, spawning, scoring, perfect tolerance, game over, camera or any visual change.

**Note (2026-11-27):** This entry replaces the former "drop input" TASK-005 and absorbs the former TASK-006 ("calculate horizontal overlap").

### TASK-007 — Apply the cut-off result
**Status:** PLANNED

**Goal:** Update the placed pancake so only the overlapping portion remains.

**Scope:**
- Update the pancake's actual visual dimensions and position.
- Ensure its gameplay dimensions match its visible dimensions.
- Preserve the correct stack alignment.
- Do not rely on hiding overhang while retaining the original dimensions.

**Acceptance criteria:**
- Partial placements visibly retain only the overlap.
- The resulting pancake becomes the reference for the next placement.
- Repeated placements use the updated dimensions correctly.

### TASK-008 — Spawn the next pancake
**Status:** PLANNED

**Goal:** Create and activate the next moving pancake after a successful placement.

**Scope:**
- Spawn one new pancake at the correct height.
- Set its width based on the previous placement result.
- Start it moving in the next alternating direction.
- Prevent more than one active moving pancake at a time.

**Acceptance criteria:**
- Every successful placement produces exactly one next pancake.
- Its dimensions and starting position are correct.
- No duplicate active pancakes are created.

---

## Milestone 4 — Score and difficulty

### TASK-009 — Implement basic scoring
**Status:** PLANNED

**Goal:** Award points for successful placements and display the current score.

**Scope:**
- Define a configurable base score.
- Update the score after successful placements.
- Display the current score.
- Do not implement coins, currencies or monetization.

**Acceptance criteria:**
- Score increases correctly after each successful placement.
- Failed placements do not award normal placement points.
- Displayed score matches the internal score.

### TASK-010 — Implement perfect-placement bonus
**Status:** PLANNED

**Goal:** Award bonus points when a placement falls within the configured perfect tolerance.

**Scope:**
- Use the perfect-placement result from the overlap calculation.
- Preserve full pancake width for a perfect placement.
- Award configurable bonus points.
- Provide simple placeholder feedback, such as a text label.

**Acceptance criteria:**
- Perfect placements preserve full width.
- Perfect placements award the bonus once.
- Non-perfect placements do not receive the bonus.
- Detection is consistent around the tolerance boundary.

### TASK-011 — Implement increasing movement difficulty
**Status:** PLANNED

**Goal:** Gradually increase pancake movement speed as the stack grows.

**Scope:**
- Define initial speed, progression and maximum speed.
- Keep tuning values configurable.
- Avoid abrupt or unbounded speed increases.

**Acceptance criteria:**
- Speed increases according to the configured progression.
- Speed never exceeds the configured maximum.
- Restarting a run resets difficulty.

---

## Milestone 5 — Camera and run lifecycle

### TASK-012 — Implement camera following
**Status:** PLANNED

**Goal:** Keep the current stacking object and top of the stack visible as the tower grows.

**Design requirement:** The camera should follow the height of the current stacking object.

**Scope:**
- Follow the active stacking height.
- Keep the active pancake and the top of the existing stack in view.
- Avoid unnecessary horizontal camera movement.
- Use smooth movement only if it does not make the active pancake difficult to track.
- Tune camera offset and framing during testing.

**Acceptance criteria:**
- The active pancake remains visible as the tower grows.
- The camera does not jump unpredictably.
- The player can still judge the alignment between the active pancake and the stack.

### TASK-013 — Implement game-over state
**Status:** PLANNED

**Goal:** End the run when a pancake completely misses.

**Scope:**
- Detect complete miss.
- Stop active gameplay.
- Display final score and a placeholder game-over interface.

**Acceptance criteria:**
- A complete miss ends the run once.
- No further placements are accepted after game over.
- Final score is displayed correctly.

### TASK-014 — Implement restart
**Status:** PLANNED

**Goal:** Allow the player to start a fresh run.

**Scope:**
- Reset score, stack, movement speed, direction and game state.
- Remove or reset old pancake instances.
- Return the camera to the starting position.

**Acceptance criteria:**
- Restart produces a clean new run.
- No state from the previous run leaks into the new run.
- Restart works repeatedly.

---

## Milestone 6 — Persistence and prototype validation

### TASK-015 — Save local high score
**Status:** PLANNED

**Goal:** Persist the player's best score between sessions.

**Scope:**
- Save the best score locally.
- Load it when the game starts.
- Update it only when a new best is achieved.
- Handle missing or invalid save data safely.

**Acceptance criteria:**
- Best score survives closing and reopening the game.
- Lower scores do not overwrite the best score.
- Save failure does not crash the game.

### TASK-016 — Prototype validation and bug fixing
**Status:** PLANNED

**Goal:** Test the complete basic gameplay loop.

**Scope:**
- Test repeated stacking.
- Test left and right overhang.
- Test perfect placements.
- Test complete misses.
- Test camera tracking.
- Test game over and restart.
- Test local high-score persistence.
- Test desktop mouse and mobile touch where available.

**Acceptance criteria:**
- A complete run can be played from start to game over.
- Restart works.
- No known blocking bugs remain.
- Any remaining limitations are documented.

---

## Later milestones — Not part of the initial skeleton

These tasks must be separately designed and approved:

- Wife's OC artwork integration.
- Final pancake illustrations and visual effects.
- Character animation.
- Potential 2.5D visual presentation (pancakes with thickness, rounded edges and shading; lighting, shadows and depth; richer environment; more dimensional character; wobble and falling animations; camera effects). Future direction only: see `game_design.md` section 9.4 and `docs/TECHNICAL_DESIGN.md` section 13. This is not an authorized task, and prototype tasks must remain 2D.
- Sound effects and music.
- Polished UI and menus.
- Coin economy and recovery.
- Rewarded advertisements.
- Online leaderboards.
- Cosmetics and unlockables.
- Analytics and publishing integrations.

---

## Current authorization

**TASK-005 is implemented and awaiting owner review.** TASK-001 to TASK-004 are DONE. TASK-007 (apply the cut-off result) and TASK-008 (spawn the next pancake) remain PLANNED and are not authorized.

Do not start TASK-007 or any later task until the project owner explicitly authorizes it.
