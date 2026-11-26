# AI DEVELOPMENT INSTRUCTIONS
## Pancake Stacker

**Applies to:** Claude, WorkBuddy and any other AI coding assistant  
**Version:** 0.1

These instructions govern how AI assistants work in this repository. They supplement `game_design.md`; they do not replace it.

---

## 1. Source of truth

Before making changes, read:

1. `game_design.md` — game vision and gameplay rules.
2. `docs/TECHNICAL_DESIGN.md` — current technical conventions and architecture.
3. `docs/TASKS.md` — task status and authorized next task.
4. This file — working rules.

If documents conflict, do not silently choose one. Report the conflict and ask the project owner which direction to follow.

The project owner (the user) makes final design and implementation decisions.

## 2. Work only on the assigned task

- Only implement the task explicitly assigned by the project owner.
- Do not begin later tasks just because they appear in `TASKS.md`.
- Do not interpret the full GDD as permission to implement every feature.
- Do not add unrequested features, polish or monetization.
- If the assigned task reveals a necessary prerequisite, explain it and request approval before expanding scope.

## 3. Small, understandable changes

- Prefer small components with clear responsibilities.
- Keep scripts readable and appropriately sized.
- Use descriptive names for scenes, nodes, scripts, variables and functions.
- Avoid unnecessary abstractions, frameworks, dependencies and global systems.
- Do not compress code merely to reduce line count.
- Avoid duplicating logic when a small, clear shared function is appropriate.
- Do not create a component before it is needed by an approved task.
- Keep gameplay calculations separate from presentation and UI wherever practical.

## 4. Inspect before editing

Before changing files:

- Inspect the relevant existing scene and scripts.
- Understand how the current implementation works.
- Identify which files need to change.
- Avoid replacing whole files when a targeted change is sufficient.
- Preserve working functionality unless the task explicitly requires changing it.

Never assume the repository is in the state you expect. Another assistant may have worked on it since your previous session.

## 5. Protect existing work

- Do not delete or rename files without a clear reason and approval.
- Do not overwrite user artwork or source assets.
- Do not change project settings unrelated to the assigned task.
- Do not introduce plugins or external dependencies without approval.
- Do not modify unrelated systems as part of cleanup.
- If you find unrelated bugs, document them rather than silently expanding the task.

## 6. Godot and GDScript conventions

- Target the Godot 4 version already used by the project; do not upgrade the engine without approval.
- Use GDScript unless the project owner explicitly approves another language.
- Follow Godot naming conventions consistently.
- Prefer exported variables for values that need tuning in the Inspector.
- Use typed variables and function return types where they improve clarity.
- Use signals for decoupled communication when appropriate; avoid unnecessary signal complexity.
- Keep scene responsibilities clear.
- Avoid physics simulation for pancake overlap calculations unless the project owner approves a design change. The intended stacking calculation is deterministic and mathematical.
- Ensure visual dimensions and gameplay dimensions remain consistent.

## 7. Testing requirements

After implementation:

- Run the project in Godot when the environment permits.
- Check the Output and Debugger panels for errors and warnings.
- Test the exact behavior described in the task's acceptance criteria.
- Do not claim something was tested if it was only inspected in code.
- If the project cannot be run, state why and provide the checks that were performed.
- Do not proceed to another task when the current task has known blocking failures.

## 8. Documentation and handover

At the end of each assigned task:

- Update `docs/TASKS.md` to reflect the real status.
- Add a concise entry to `docs/CHANGELOG.md`.
- Update `docs/TECHNICAL_DESIGN.md` if the architecture, file responsibilities, conventions or interfaces changed.
- Do not mark a task complete unless its acceptance criteria have been met.
- Record known issues and unfinished work.
- Identify the next task, but do not start it without approval.

Keep documentation factual and concise. Do not claim features exist when they are only planned.

## 9. Git and collaboration

Claude and WorkBuddy work sequentially, not simultaneously.

- Never assume another assistant's uncommitted changes are disposable.
- Inspect `git status` before making changes when Git is available.
- Do not reset, clean, force-push, rewrite history or discard user changes.
- Do not commit unless the project owner has asked you to commit or has established that permission.
- If asked to commit, make a focused commit for the completed task.
- Report changed files and any uncommitted changes at handover.

The project owner reviews and tests each milestone before the next task is approved.

## 10. Required final report

When a task is finished, provide:

1. **Task:** The assigned task identifier and title.
2. **Result:** What was implemented.
3. **Files changed:** List each created, modified or deleted file.
4. **Testing:** What was actually run and tested, including results.
5. **Known issues:** Bugs, limitations or unverified behavior.
6. **Documentation:** Which project documents were updated.
7. **Git status:** Whether changes are committed or remain uncommitted.
8. **Next task:** The next suggested task, without starting it.

Be honest about incomplete work. Do not report success merely because code was written.

---

**Core rule: One task → one implementation → one test → one review → approval before the next task.**
