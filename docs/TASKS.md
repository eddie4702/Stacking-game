# DEVELOPMENT TASKS
## Pancake Stacker

**Version:** 0.1  
**Status key:** `READY` = may be assigned; `PLANNED` = not yet authorized; `IN PROGRESS` = currently being worked on; `REVIEW` = awaiting owner review; `DONE` = accepted and tested.

> Important: This is the roadmap, not blanket permission to implement everything. Only Task 001 is initially ready. The project owner must explicitly authorize each next task.

---

## Milestone 1 — Project foundation

### TASK-001 — Create the Godot project foundation
**Status:** REVIEW

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

**Result (2026-11-26):** Implemented and awaiting owner review.
- `project.godot` configured: 720x1280 portrait viewport, portrait handheld orientation, 405x720 desktop window override, main scene set. Existing stretch settings (`canvas_items` / `expand`) left unchanged.
- `scenes/main/main.tscn` created: solid placeholder background plus a placeholder gameplay area. No scripts.
- Tested with Godot 4.7-stable: project imports and runs headless with no errors or warnings; a software-rendered screenshot was inspected at several window sizes. Not tested on a real GPU, in the Godot editor UI, in a browser, or on a mobile device.
- Known issues and items to verify manually are listed in the TASK-001 completion report and in `docs/CHANGELOG.md`.

### TASK-002 — Create a reusable pancake scene
**Status:** PLANNED

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

---

## Milestone 2 — Movement and input

### TASK-003 — Implement horizontal pancake movement
**Status:** PLANNED

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

### TASK-004 — Implement alternating direction
**Status:** PLANNED

**Goal:** Make successive pancakes travel in alternating directions.

**Scope:**
- First pancake travels left-to-right.
- Next travels right-to-left.
- Continue alternating after each successful placement.

**Acceptance criteria:**
- Direction alternates reliably.
- Restarting a run resets direction consistently.

### TASK-005 — Implement drop input
**Status:** PLANNED

**Goal:** Allow the player to stop the active pancake with one action.

**Scope:**
- Support touch input on mobile.
- Support left mouse click on desktop/web.
- Prevent multiple drops from one input or drops after the game is no longer active.
- Keep input handling separate from the pancake's movement implementation where practical.

**Acceptance criteria:**
- One tap/click stops the active pancake exactly once.
- Both input methods work.
- Input cannot trigger invalid state transitions.

---

## Milestone 3 — Stacking

### TASK-006 — Calculate horizontal overlap
**Status:** PLANNED

**Goal:** Calculate the intersection between the moving pancake and the pancake underneath.

**Scope:**
- Use deterministic mathematical calculations.
- Handle left and right overhang.
- Detect complete misses.
- Detect perfect alignment using a configurable tolerance.
- Keep the calculation independently testable where practical.

**Acceptance criteria:**
- Correct overlap width and position are calculated for left overhang, right overhang and exact alignment.
- Complete misses are detected.
- Edge cases are handled without negative or invalid dimensions.

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

**TASK-001 is implemented and awaiting owner review.** No other task is authorized.

Do not start TASK-002 or any later task until the project owner reviews the completed foundation and explicitly approves the next step.
