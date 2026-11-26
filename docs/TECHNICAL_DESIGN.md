# TECHNICAL DESIGN
## Pancake Stacker

**Version:** 0.1 — Initial guidelines  
**Status:** Evolving document

This document records the technical decisions that have been made. It is intentionally lightweight at the beginning of development. Update it as real implementation decisions are made; do not invent a complete architecture before it is needed.

---

## 1. Technology

- **Engine:** Godot 4 (use the version already installed for the project; do not upgrade without approval).
- **Language:** GDScript.
- **Initial targets:** Desktop development and browser; mobile support is a design requirement.
- **Orientation:** Portrait.
- **Version control:** Git and the existing GitHub repository.

## 2. Architecture principles

1. Build small components with clear responsibilities.
2. Prefer readable, direct code over clever abstractions.
3. Keep gameplay rules separate from presentation and UI.
4. Use deterministic mathematical overlap calculations for pancake placement.
5. Keep tunable gameplay values easy to find and adjust.
6. Avoid premature systems for features that are not in the approved task.
7. Keep the project runnable after each task.
8. Keep gameplay coordinates, dimensions and rules independent of how pancakes are drawn, so the visual presentation can be replaced or upgraded later (see section 13).

## 3. Proposed repository layout

```text
PancakeStacker/
├── .gitignore
├── README.md
├── game_design.md
├── project.godot                 # Created during TASK-001
│
├── docs/
│   ├── AI_INSTRUCTIONS.md
│   ├── TECHNICAL_DESIGN.md
│   ├── TASKS.md
│   └── CHANGELOG.md
│
├── scenes/
│   ├── main/                     # Main game scene
│   ├── gameplay/                 # Reusable gameplay scenes
│   └── ui/                       # UI scenes
│
├── scripts/
│   ├── core/                     # Game flow and shared coordination
│   ├── gameplay/                 # Pancake movement and stacking logic
│   └── ui/                       # UI behavior
│
├── assets/
│   ├── art/
│   │   ├── characters/
│   │   ├── pancakes/
│   │   ├── backgrounds/
│   │   └── ui/
│   ├── audio/
│   │   ├── music/
│   │   └── sfx/
│   └── fonts/
│
└── tests/                        # Add only if/when a useful test approach is established
```

Create folders when they are needed. Do not add placeholder files merely to make every planned folder appear in Git.

Godot's generated `.godot/` directory is local cache data and should not be committed.

## 4. Initial component responsibilities (planned)

These are intended responsibilities, not a requirement to create all scripts immediately.

| Component | Intended responsibility |
|---|---|
| Main scene | Owns the initial scene composition and starts the game |
| Game manager | Coordinates game state and the overall run |
| Pancake scene/script | Represents one pancake and its visual/gameplay dimensions |
| Movement logic | Moves the active pancake between horizontal boundaries |
| Stacking logic | Calculates overlap, perfect placement and complete miss |
| UI manager | Displays score and game-over information |
| Camera logic | Keeps the active stacking height visible |
| Save logic | Loads and saves the local best score |

Do not split every row into its own script automatically. Choose the smallest clear design that suits the actual implementation.

## 5. Stacking calculation requirements

The intended stacking calculation is based on horizontal intervals.

For a pancake with left edge `A_left` and width `A_width`:

- `A_right = A_left + A_width`

For the moving pancake and the supporting pancake:

- `overlap_left = max(moving_left, support_left)`
- `overlap_right = min(moving_right, support_right)`
- `overlap_width = overlap_right - overlap_left`

Interpretation:

- If `overlap_width <= 0`, it is a complete miss.
- If the moving pancake aligns within the configured perfect tolerance, it is a perfect placement and its full width is retained.
- Otherwise, the overlap interval defines the remaining pancake.

Gameplay coordinates and dimensions are the source of truth for these calculations. They must not be derived from visual node sizes, sprite bounds, physics bodies or 3D collisions, so the result is the same whatever the visual presentation.

The exact coordinate representation and edge-case handling must be confirmed during implementation. Keep calculations independent enough to test with known input values.

## 6. Camera requirement

The approved design requirement is:

> The camera should follow the height of the current stacking object.

The camera should keep the active pancake and the top of the existing stack visible as the tower grows. Avoid unnecessary horizontal movement. Camera smoothing, offset and framing remain tuning decisions.

## 7. Input requirements

- Mobile: touch input in the gameplay area.
- Desktop/browser: left mouse click in the gameplay area.
- Both should trigger the same gameplay action.
- Ignore input when the game state does not allow a drop.
- Prevent duplicate placement from repeated input events.

## 8. Configuration and tuning

Values likely to need tuning include:

- Starting pancake width and height.
- Horizontal movement boundaries.
- Initial movement speed.
- Speed progression and maximum speed.
- Perfect-placement tolerance.
- Base score and perfect bonus.
- Camera offset and smoothing.

Keep these values centralized or exposed for tuning where practical. Do not create a large configuration framework for a handful of values.

## 9. Persistence

The initial persistence requirement is local best-score saving only.

Use a simple, robust local save approach appropriate for Godot and the target platforms. Handle missing or invalid save data. Do not implement accounts, cloud saves or leaderboards in the initial skeleton.

## 10. Platform considerations

The project should be designed for portrait mobile and desktop browser input from the beginning.

Test browser and mobile behavior when builds become available. Do not assume every desktop feature or storage behavior works identically in embedded browser portals.

Platform-specific export configuration and publishing integrations are later tasks.

## 11. Change management

When an implementation decision changes the architecture or component responsibilities:

1. Explain the reason.
2. Update this document.
3. Update relevant task acceptance criteria if necessary.
4. Report the change to the project owner.

Do not silently change a documented gameplay rule.

---

## 12. Current implementation state

Updated after TASK-002. Describes what exists now, not what is planned.

**Display settings (`project.godot`):**

- Base viewport 720x1280 (portrait, 9:16).
- Handheld orientation: portrait.
- Desktop window override 405x720, so the window fits on typical monitors; this does not change the 720x1280 coordinate space.
- Stretch mode `canvas_items`, aspect `expand`. Extra screen space on non-9:16 windows appears to the right and below the 720x1280 area.
- Renderer: Mobile (unchanged from the generated project).

**Main scene (`scenes/main/main.tscn`, no scripts):**

```text
Main (Node2D)
├── Background (CanvasLayer, layer -1)
│   └── BackgroundColor (ColorRect, full-screen)
├── GameplayArea (ColorRect, placeholder, 600x960 at 60,160)
└── Pancake (instance of scenes/gameplay/pancake.tscn, at 360,640)
```

- The background sits on its own CanvasLayer so it stays fixed on screen and covers any window shape; this keeps it unaffected by a camera added later.
- `GameplayArea` is a visual placeholder only. Its position and size are not final design decisions and carry no gameplay meaning yet.
- The `Pancake` instance is a static placeholder showing that the pancake scene can be reused. It does not move. Later tasks will replace it or spawn pancakes in code.

**Pancake scene (`scenes/gameplay/pancake.tscn`, script `scripts/gameplay/pancake.gd`):**

```text
Pancake (Node2D, pancake.gd)
└── Visual (ColorRect)
```

- **Configuration:** exported `width` and `height` (pixels, default 300 and 40) and `color` (default golden). Set them in the Inspector, or from code before or after adding the pancake to the tree. Negative sizes are clamped to 0. The defaults are placeholders; GDD section 16 item 1 (starting size) is still undecided.
- **Gameplay values and visual:** `width` and `height` on the `Pancake` node are the pancake's dimensions, and other code should read them from there. `Visual` only draws them: the script resizes and recolours it whenever a value changes, so the visual cannot drift from the dimensions (see sections 5 and 13).
- **Origin:** the centre of the pancake; `Visual` is offset by half its size. This was chosen in TASK-002 so a pancake resizes symmetrically. The edges are therefore `position.x - width / 2` and `position.x + width / 2`. It is a TASK-002 implementation choice, to be confirmed when overlap is implemented (section 5).
- **Editor:** the script is `@tool`, so changes to `width`, `height` or `color` show immediately in the editor.
- **Input:** `Visual` has `mouse_filter` set to Ignore, as a precaution so it never intercepts mouse events. This has not been verified in a running game.
- **No behaviour:** no processing or input callbacks, no signals, and no movement, stacking, scoring or physics logic.
- **Reuse:** instance `pancake.tscn` from another scene or with `load("res://scenes/gameplay/pancake.tscn").instantiate()`, set `width`, `height` and `color`, then set `position`.

**Folders in use:** `scenes/main/`, `scenes/gameplay/`, `scripts/gameplay/`, `docs/`. Other folders in section 3 are created when a task needs them.

---

## 13. Future visual direction: 2.5D (not current scope)

**Status:** Recorded direction only. Not an authorized task. No migration to 3D is planned for the prototype.

The prototype and gameplay stay 2D. The longer-term goal, described in `game_design.md` section 9.4, is to potentially upgrade the game to a polished 2.5D presentation before release: thicker, rounded, shaded pancakes; lighting, shadows and depth; a richer environment; a more dimensional character; and more expressive animation and camera effects.

**What this means for current work:**

- Implement all prototype tasks in 2D. Do not add 3D nodes, perspective cameras, 3D models, dynamic lighting or 2.5D effects.
- Do not add abstraction layers or placeholder systems "for later". The existing rules already cover what is needed.
- Gameplay calculations (overlap, cutting, perfect placement, scoring, game over) use gameplay coordinates and dimensions only, as described in section 5.
- A pancake's visuals are derived from its gameplay position and dimensions. This is consistent with the existing requirement that visual and gameplay dimensions stay synchronized; gameplay is the source of truth.
- Visual reactions such as wobbling or falling are presentation only and must not change gameplay outcomes.

**Not decided:** how a 2.5D presentation would be built (for example, enhanced 2D art or a separate 3D presentation driven by the same gameplay state). This should be evaluated after the core gameplay is validated, as a separately designed and approved task, with this document updated per section 11.
