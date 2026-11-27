# PANCAKE STACKER
## Game Design Document (GDD)

**Version:** 0.3 — Draft for Review  
**Project status:** Pre-production  
**Engine:** Godot 4  
**Programming language:** GDScript  
**Platforms:** Mobile and Web (desktop browser)  
**Orientation:** Portrait  
**Genre:** Casual Arcade / High-Score Stacker  
**Working title:** Pancake Stacker

---

## 1. Game Overview

Pancake Stacker is a casual arcade stacking game built around a simple but challenging one-touch gameplay mechanic.

The player controls the placement of giant pancakes, stacking them on top of one another while attempting to achieve the highest possible tower and score.

Each pancake moves horizontally across the screen. The player taps or clicks to drop it onto the existing stack. Accuracy determines how much of the pancake remains after landing.

A perfectly aligned pancake retains its entire width and awards bonus points. An imperfect placement results in the overhanging portion being cut away, making subsequent placements increasingly difficult.

The objective is to stack as many pancakes as possible, achieve high scores, and beat previous records.

The game should be easy to understand, immediately playable, and challenging enough to encourage repeated attempts.

## 2. Core Design Philosophy

- **Simple controls:** One primary action: tap or click to drop.
- **Easy to understand:** Players should understand the objective within seconds.
- **Skill-based:** Accurate timing should be rewarded.
- **Increasing challenge:** The game gradually becomes more difficult.
- **Satisfying feedback:** Successful placements should feel rewarding.
- **Replayability:** Players should want to immediately try again and beat their previous score.
- **Expandable design:** The initial game should provide a foundation for future characters, cosmetics, progression and monetization.

The initial development priority is gameplay quality, not visual polish or monetization.

## 3. Core Gameplay Loop

1. A pancake appears above the existing stack.
2. The pancake moves horizontally across the screen.
3. The player taps or clicks to drop it.
4. The game calculates the horizontal overlap between the moving pancake and the pancake underneath.
5. If the pancake overlaps, the overhanging portion is removed.
6. The remaining portion becomes the new top of the stack.
7. The player receives points.
8. A new pancake spawns and moves in the opposite direction.
9. The process repeats until the player misses completely or uses a future recovery feature.

The initial prototype ends the run after a complete miss. Recovery is a later feature.

## 4. Pancake Movement

### 4.1 Horizontal Movement

Pancakes move horizontally from one side of the screen to the other.

Movement follows an alternating direction pattern:

- First pancake moves from left to right.
- Second pancake moves from right to left.
- Third pancake moves from left to right.
- This continues throughout the game.

The pancake reverses direction when it reaches its movement boundary.

Movement should remain continuous and smooth.

### 4.2 Movement Speed

Movement speed should gradually increase as the player successfully stacks more pancakes.

The difficulty system should be configurable, allowing adjustment of:

- Initial movement speed.
- Speed increase per successful placement.
- Maximum movement speed.
- Whether difficulty increases continuously or in stages.

Exact balancing values will be determined through testing.

### 4.3 Movement Boundaries

Pancakes should move within a defined horizontal movement area.

The movement area should account for the current pancake width and screen boundaries, preventing pancakes from moving partially outside the playable area before being dropped.

## 5. Stacking Mechanics

### 5.1 Placement

When the player taps or clicks, the moving pancake immediately stops and begins its placement calculation.

The game compares its horizontal position and width with the pancake directly underneath it.

A stationary base pancake exists at the bottom of the stack. The player never moves or places this pancake. It supports the first moving pancake. Its initial width and position remain configurable.

After the first placement, the support is always the immediately preceding placed pancake, not the original base pancake.

### 5.2 Overlap Calculation

There are three possible outcomes:

**Perfect placement**
- The pancake aligns with the pancake underneath within an acceptable tolerance.
- Its entire width is preserved.
- The player receives bonus points.

**Partial placement**
- The pancake overlaps the previous pancake but extends beyond one or both edges.
- The overhanging section is removed.
- The remaining section becomes the new top pancake.
- The player receives normal points.

**Complete miss**
- The pancake does not overlap the previous pancake.
- The placement fails.
- The initial prototype ends the run.

### 5.3 Cutting Mechanic

The overhanging portion must be visually removed.

For the initial prototype, this can be represented using simple rectangles.

The remaining pancake must have its actual width and position updated to match the calculated overlap.

The game must not simply hide the overhanging section while retaining the original stacking dimensions.

All subsequent placements must use the actual remaining dimensions.

The first moving pancake inherits the base pancake's width. Every subsequent moving pancake inherits the width of the most recently placed pancake. Width must never reset to the original base width, so each placement can progressively reduce the width of the stack.

Every overlap calculation uses the actual position and width of the immediately preceding placed pancake. The overlap calculation returns the new centre in the shared gameplay coordinate system; this absolute centre must be preserved for subsequent placements.

### 5.4 Stack Growth

Each successful placement increases the stack height.

The stack should remain visually aligned and centered around its actual calculated positions.

A placed pancake's Node2D root uses the absolute centre returned by the overlap calculation. Its visual is centred around that root. A centre measured from the surviving pancake's own left edge is only a local value and must not be used as the gameplay X position.

As the tower grows, the camera must keep the active stacking area visible.

**Camera requirement:** The camera should follow the height of the current stacking object. The implementation should keep the currently active pancake and the top of the existing stack visible as the tower grows. Exact camera smoothing, offset and framing can be tuned during implementation.

## 6. Scoring System

### 6.1 Normal Placement

Successful pancake placements award points.

The exact base score is still to be determined.

### 6.2 Perfect Placement

A perfect placement preserves the entire pancake width.

Perfect placements award additional bonus points.

The game should provide clear visual feedback when a perfect placement occurs.

### 6.3 Perfect Placement Detection

Perfect placement should use a configurable tolerance in pixels rather than requiring mathematically exact alignment.

The tolerance must be tested and balanced so the game feels fair.

### 6.4 Future Scoring Expansion

Possible future additions:

- Consecutive perfect placement bonuses.
- Combo multipliers.
- Milestone bonuses.
- Special score effects.
- High-score achievements.

These are not required for the initial playable prototype.

## 7. Game Over and Recovery

### 7.1 Game Over

When a pancake completely misses the stack:

- The current run ends.
- The final score is displayed.
- The player's high score is updated if necessary.
- The player can restart and attempt another run.

### 7.2 Future Recovery System

Recovery will eventually allow players to continue a run after making a mistake.

Potential recovery methods:

**Coin recovery**
- Players spend earned in-game coins to continue.

**Rewarded advertisements**
- Players can optionally watch an advertisement to continue.

These features are planned for a later development phase.

The initial prototype does not need a functioning coin economy, advertisement integration or recovery mechanic. The initial game-over flow should be simple. A placeholder continue button is optional and must not imply that recovery already works.

## 8. High Scores and Saving

The game should track:

- Current score.
- Best score.
- Current stack height.

The best score should persist between game sessions using local storage.

For the initial prototype, an online leaderboard is not required.

Future possibilities include:

- Global leaderboards.
- Friends' leaderboards.
- Daily high scores.
- Personal records and achievements.

## 9. Visual Direction

### 9.1 Initial Prototype

The initial prototype will use placeholder graphics.

Examples:

- Pancakes represented by simple colored rectangles.
- Character represented by a basic placeholder shape.
- Background represented by a solid color.
- Basic text for score and high score.

The purpose is to validate gameplay before investing time in final artwork.

### 9.2 Final Character Concept

The planned visual concept features a character standing beneath the pancake tower.

The character holds both hands upwards, appearing to physically support or lift the growing stack of giant pancakes.

The character will eventually be represented by the original character (OC) designed by the studio's artist.

The character should become an important part of the game's visual identity.

### 9.3 Art Direction

The final art style is not locked yet.

We intend to explore a 2D illustrated character with potentially dimensional or 2.5D-inspired environments and objects.

The final art direction should preserve the wife's original OC art style rather than forcing it into a generic mobile-game aesthetic.

Artwork, textures, character animations, backgrounds and polished UI will be implemented after the gameplay skeleton is functional.

### 9.4 Long-Term Visual Direction (Future, Not Current Scope)

The initial prototype and all gameplay implementation remain 2D. The project is not being migrated to 3D during prototype development.

The longer-term visual goal is to potentially upgrade the game to a polished 2.5D presentation before release: a game that looks and feels more three-dimensional while retaining relatively simple, deterministic stacking gameplay.

Possible future visual improvements:

- Pancakes with visible thickness, rounded edges and dimensional shading.
- More convincing lighting, shadows and depth.
- A 2.5D perspective and a richer environment.
- A more dimensional character presentation.
- More expressive animations, such as wobbling, falling reactions and camera effects.

Constraints on this direction:

- It is a future direction, not a requirement. Whether and how to do it will be decided after the core gameplay has been validated (see section 16, item 11).
- Presentation must not change gameplay rules. Overlap, cutting, scoring and game over are based on gameplay coordinates and dimensions (see section 12), however the pancakes are drawn.
- Visual reactions such as wobbling or falling are presentation only and should not change gameplay outcomes.
- Nothing in this section changes the prototype scope in sections 13 and 14.

## 10. User Interface

The initial prototype should contain:

**Gameplay screen**
- Current score.
- Best score.
- Active pancake.
- Existing pancake tower.
- Character placeholder.

**Game-over screen**
- Final score.
- Best score.
- Restart button.

The UI should be designed for portrait orientation.

Buttons and text should remain readable on different mobile screen sizes.

The initial interface can use Godot's standard UI elements and placeholder styling.

## 11. Controls

**Mobile**
- Tap in the designated gameplay area to drop the pancake.

**Desktop / Web**
- Left mouse click in the designated gameplay area to drop the pancake.
- Keyboard input may be added for development and testing if useful.

The game should support touch and mouse input without requiring separate gameplay implementations.

## 12. Technical Direction

### Engine
Godot 4.

### Programming Language
GDScript.

### Gameplay Architecture

The initial implementation should use deterministic mathematical calculations for pancake placement rather than relying on a physics simulation.

This is preferable because the game requires precise, repeatable overlap calculations.

The gameplay should be coordinated by a central game manager, while individual responsibilities should remain separated into small, understandable components.

Suggested initial structure:

- `scenes/`
  - `main/`
  - `gameplay/`
  - `ui/`
- `scripts/`
  - `core/`
  - `gameplay/`
  - `ui/`
- `assets/`
  - `art/`
  - `audio/`
  - `fonts/`
- `docs/`

This structure may be adjusted as the project develops. Do not create empty systems or unnecessary abstractions just to fill the folders.

### Gameplay and Presentation Separation

Gameplay rules and calculations must be independent of the visual representation wherever reasonably practical.

- Pancake overlap, cutting, perfect-placement detection and scoring are calculated from gameplay coordinates and dimensions, not from visual node sizes, visual physics or 3D collisions.
- A pancake's visual representation is derived from its gameplay position and dimensions. Gameplay values are the source of truth.
- The same inputs must give the same gameplay results whether pancakes are drawn as placeholder rectangles, illustrated 2D art or a possible future 2.5D presentation (see section 9.4).

This is a separation of responsibilities, not a reason to add abstraction layers now. Do not build extra systems in preparation for a future presentation.

### Important Technical Requirements

- Use a consistent coordinate system.
- Keep pancake dimensions synchronized with their visual representation.
- Keep gameplay calculations independent of visual representation (see Gameplay and Presentation Separation above).
- Make stacking calculations deterministic.
- Keep movement speed and perfect-placement tolerance configurable.
- Separate gameplay logic from UI logic.
- Keep high-score saving separate from gameplay logic.
- Avoid unnecessary dependencies.
- Avoid premature architecture complexity.
- Implement and test one small component at a time.

## 13. Initial Development Scope

The first playable version should eventually include:

1. Godot project setup.
2. Portrait gameplay layout.
3. Placeholder character.
4. Horizontally moving pancakes.
5. Alternating movement directions.
6. Tap and mouse-click input.
7. Pancake placement.
8. Overlap calculations.
9. Overhang removal.
10. Perfect placement detection.
11. Normal and bonus scoring.
12. Increasing movement speed.
13. Stack growth.
14. Camera following the height of the current stacking object.
15. Game-over state.
16. Restart functionality.
17. Persistent local high score.

These features must be implemented incrementally as separate tasks, not all in one pass.

## 14. Explicitly Out of Scope for Initial Prototype

Do not implement these features unless explicitly requested:

- Final OC artwork.
- Final pancake illustrations.
- Character animation.
- 2.5D or 3D presentation (see section 9.4).
- Particle effects.
- Sound effects.
- Music.
- Coin economy.
- Rewarded advertisements.
- In-app purchases.
- Online leaderboards.
- Multiplayer.
- Account registration.
- Unlockable characters.
- Cosmetic shops.
- Daily challenges.
- Complex progression systems.

These features may be introduced after the core gameplay has been validated.

## 15. Development and Quality Goals

The initial prototype should prioritize:

- Responsive controls.
- Consistent placement calculations.
- Smooth pancake movement.
- Understandable scoring.
- Fair difficulty progression.
- Reliable restart functionality.
- Stable performance on desktop and mobile.

The game should be tested frequently during development.

Every task should be tested before moving on to the next one.

## 16. Outstanding Design Decisions

The following details are intentionally left undecided:

1. Exact pancake starting width and height.
2. Initial pancake movement speed.
3. Maximum movement speed.
4. Speed progression formula.
5. Perfect placement tolerance.
6. Base points per successful placement.
7. Perfect placement bonus value.
8. Camera smoothing, offset and framing.
9. Whether the tower has a maximum visible height before camera scrolling.
10. Whether pancakes eventually become narrower than a minimum threshold.
11. Final visual perspective: 2D or 2.5D-inspired. (A possible 2.5D upgrade is recorded as a future direction in section 9.4; it is not decided and not needed for the prototype.)
12. Exact character placement and proportions.
13. Whether the game will include a separate title screen.

These decisions can be made as development progresses.

## 17. Project Vision

Pancake Stacker is intended to be the first game in a broader collection of small, polished, recognizable casual games developed by our studio.

The long-term objective is to establish a distinctive visual identity around original characters and artwork while experimenting with accessible, replayable gameplay concepts.

The first milestone is not monetization or a large feature set.

It is creating a small game that feels good to play, encourages repeated attempts and gives us a solid technical foundation for future releases.

---

**END OF GDD — VERSION 0.3**
