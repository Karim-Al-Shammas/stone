# Handoff: FitForge — Chrysler Art Deco Redesign

## Overview
A complete visual + structural redesign of **FitForge**, a mobile fitness tracker (workouts, exercises, PRs, progress charts, rest timer). The redesign applies an **Art Deco / Chrysler Building** aesthetic — Cinzel Roman capitals, ink-on-cream palette with brass accents, sunburst spire ornaments, and stepped pyramid crown motifs.

The original app is a single-file `index.html` mobile webapp (https://github.com/Karim-Al-Shammas/stone). This handoff covers a redesigned version of the same feature set across **7 screens**.

## About the Design Files
The files in this bundle are **design references created in HTML/JSX** — prototypes showing intended look and behavior, **not production code to copy directly**. They use React via Babel-in-browser and a custom design-canvas wrapper for side-by-side presentation.

The task is to **recreate these designs in the target codebase's existing environment** (React, React Native, Vue, SwiftUI, native iOS, etc.) using its established patterns and libraries. If no codebase exists yet, choose the most appropriate framework and implement there. Do not ship the prototype HTML directly.

## Fidelity
**High-fidelity (hifi).** Pixel-perfect mockups with final colors, typography, spacing, ornament, and interactions. Recreate the UI faithfully using the target codebase's libraries and patterns. The original app uses vanilla JS + Tailwind-like inline styles in a single HTML file; the redesign should follow whatever the team adopts going forward.

## Design Tokens

### Colors
| Token | Hex | Usage |
|---|---|---|
| `cream` | `#f3ead7` | App background |
| `creamDeep` | `#e8dcc1` | Hatched fills, secondary surfaces |
| `paper` | `#fbf6e9` | Card / surface background |
| `ink` | `#1a1612` | Primary text, dark surfaces (nav, button) |
| `inkSoft` | `#3a312a` | Secondary text, muted glyphs |
| `brass` | `#b8893a` | Primary accent, borders, ornament |
| `brassDeep` | `#8a6321` | Strong accent, kickers, button on dark |
| `brassLight` | `#d4a857` | Light accent on dark surfaces |
| `gold` | `#c89a3e` | Highlight accent |
| `line` | `rgba(26,22,18,0.18)` | Card borders, dividers |
| `lineSoft` | `rgba(26,22,18,0.08)` | Inner dividers |

### Typography
- **Display:** `"Cinzel", serif` — all-caps Roman, weights 400/500/600/700. Used for headings, screen titles, large numerals, button labels.
- **Body:** `"Inter", system-ui, sans-serif` — weights 300/400/500/600/700. Used for paragraphs, list items.
- **Mono:** `"DM Mono", "SF Mono", ui-monospace, monospace` — weights 300/400/500. Used for kickers, metadata, small labels (always uppercase, letter-spaced).

Letter-spacing convention:
- Display headings: `letter-spacing: 1.5–6px` (more for shorter words)
- Mono kickers: `letter-spacing: 2–3px`, `text-transform: uppercase`, `font-size: 9–10px`

### Spacing & Layout
- App width: 390px (iPhone 14/15 design width)
- App height: 844px
- Standard horizontal padding: 20–24px
- Section gap (vertical): 22px
- Bottom nav height (with home indicator): ~88px (24px home indicator + ~64px tab bar)
- Status bar: 44px

### Ornament
- **Spire:** SVG sunburst — 11 radial lines fanning from a center-bottom point with 3 concentric arcs. Used as the central crown motif on screen headers and exercise detail. Default size 180×44 in headers, 220×70 standalone.
- **Diamond dot:** 6×6 square rotated 45°, brass-filled. Used as bullet/divider accent.
- **Stepped crown:** Removed in this locked-in design (originally a stepped pyramid bar at top of header and tab bar — both turned **off** in final).

### Borders & Surfaces
- Card border: `1px solid var(--line)` over `paper` background
- Strong card border: `1px solid var(--brass)` (used on the stats trio)
- Bottom nav: `2px solid var(--brass)` top border
- All corners are **square** — no border-radius on cards (period-correct deco). The only rounded corner is the iOS device frame itself (44px).

## Locked-in Variant Choices
The Chrysler direction was selected after exploring 5 directions (Chrysler, Miami Deco, Gatsby Noir, Bauhaus Deco, Neon Deco). Within Chrysler, the following tweak choices were made and **baked into the code**:

| Property | Value |
|---|---|
| Display + body fonts | **Cinzel · Inter** |
| Top stepped crown (header) | **Off** |
| Bottom stepped crown (tab bar) | **Off** |
| Bottom nav background | **Ink** (`#1a1612`) — light-on-dark |
| Begin Session button color | **Ink** (`#1a1612`) with cream text + brass accent border |
| Begin Session chamfered corners | **Both** (bottom-left + bottom-right notches) |
| Begin Session arrow glyphs | **Both** (▲ left and right of label) |

## Screens

### 1. Home
- **Purpose:** Landing screen — greeting, weekly stats, primary CTA, recent PRs, recent sessions.
- **Layout:** Header (centered spire + "FITFORGE" + month) → 3-column stats grid → Begin Session CTA → "Recent Records" section → "Recent Sessions" list → bottom nav.
- **Stats trio:** 3 columns, equal width, single brass border, small brass tick at top of each cell, mono kicker (WEEK / VOLUME / STREAK), large Cinzel value, mono unit.
- **CTA:** Full-width, ink bg, cream text, both bottom corners chamfered (8px clip-path), 3px brass border offset (11px chamfer), `▲ BEGIN SESSION ▲` in Cinzel @ 18px, letter-spacing 6.
- **Recent Records:** 3 rows, each with numbered brass-bordered square, exercise name + date, weight × reps right-aligned in Cinzel.
- **Recent Sessions:** 3 cards, each showing workout name (Cinzel uppercase), metadata row, chevron right.

### 2. Workouts
- **Purpose:** Browse all logged workouts.
- **Layout:** Header → "+ NEW SESSION" CTA (ink bg, full width) → list of workout cards.
- **Cards:** Each workout card shows name (Cinzel large), date (mono brass right-aligned), metadata row (exercise count · sets · minutes), and tag chips (brass border, mono small).

### 3. Active Workout
- **Purpose:** Live workout session — track sets/reps/weight, rest timer.
- **Layout:** Top bar with `‹ CANCEL` / elapsed timer / `···` → workout name centered + brass underline → rest banner → exercise blocks → `+ ADD EXERCISE` → `✓ CONCLUDE SESSION` button.
- **Rest banner:** Ink background, cream text, "REST" mono kicker, large Cinzel timer, two square outlined buttons on right (pause `▌▌` and reset `↺`).
- **Exercise block:** Paper card with exercise name + muscle kicker header, then a set table with columns SET / KG / REPS / ✓. Completed sets get a faint brass-tint background and a filled brass checkmark. Dashed-brass `+ ADD SET` row at bottom.

### 4. Progress
- **Purpose:** Strength charts and PR list.
- **Layout:** Header → exercise selector ("BENCH PRESS ▾") → chart card → 3-up summary stats → "Hall of Records" list.
- **Chart:** Custom SVG line chart, brass stroke, diamond-shaped data points (rotated squares with cream fill + brass stroke), 5 horizontal gridlines (alternating dashed). Top edge of chart card has a repeating brass dash pattern.
- **Summary:** 3 paper cards — CURRENT / GAINED / PEAK.
- **Records list:** Each row has a brass-outlined diamond icon, name, date, weight in Cinzel.

### 5. Library
- **Purpose:** Browse exercise catalogue.
- **Layout:** Header → search field → muscle filter chips (horizontal scroll, first one ink-active) → exercise list.
- **Exercise row:** Brass-bordered square with first-letter glyph, name (Inter 14 medium), muscle + type kicker (mono brass), chevron.

### 6. Detail
- **Purpose:** Single exercise — form description, cues, personal record.
- **Layout:** `‹ LIBRARY` back link → centered spire ornament → muscle/type kicker → exercise name in Cinzel @ 36px (letter-spacing 3) → 3 diamond dots → demo image placeholder (45° hatched cream stripes) → FORM section → CUES section (numbered list 01/02/03) → record card (ink bg, cream text, brass-light kickers).

### 7. Picker (Add Exercise modal)
- **Purpose:** Modal sheet to add an exercise to the active workout.
- **Layout:** Sheet rises from bottom, brass top border, stepped-crown decoration on sheet top edge, "SELECT" mono kicker, "ADD EXERCISE" Cinzel title, search field, muscle filter chips, exercise list with `+` action button per row. Background app peeks through with 45% ink overlay + slight blur.
- Note: The "stepped crown" on the modal is the modal's own decoration and was **kept** even though the app-level top/bottom crowns are off.

## Interactions & Behavior
The original FitForge app handles full state — workouts in progress, set checking, rest timer counting down, localStorage persistence. The redesign should preserve all original behavior:

- **Begin Session** → opens a new workout in the Active Workout screen
- **Active Workout:** tap row to edit kg/reps; checkbox marks set complete and starts rest timer; timer counts down with pause/reset
- **+ Add Exercise** opens the Picker modal (slide up from bottom)
- **Conclude Session** writes the workout to history and returns to Home
- **Charts** pull from logged sessions (per-exercise weight progression, all-time PR per exercise)
- **Tabs:** Home / Forge / Charts / Library — preserve original tab routing

Refer to the original `index.html` from the source repo for the full behavioral spec.

## Files in this Bundle
- `FitForge Redesign.html` — entrypoint; loads React + Babel + the JSX modules
- `app.jsx` — top-level wiring; renders the design canvas with 7 Chrysler artboards
- `variants/chrysler.jsx` — **the design source of truth.** Contains all 7 screen components (Home, Workouts, Active, Progress, Library, Detail, Picker), the color/font tokens, the Spire/StepCrown/DiamondDot ornament components, the Header, and the TabBar.
- `variants/_shared.jsx` — mock data for the prototype (user, stats, recent workouts, exercises, etc.). Replace with real app state in production.
- `ios-frame.jsx` — iPhone bezel for presentation only; **do not port**
- `design-canvas.jsx` — Figma-style canvas wrapper for presentation only; **do not port**

## Implementation Notes
- The `cfg()` function inside `chrysler.jsx` returns hardcoded values for the 6 baked-in tweak choices. In production these should just be inlined; no need for a config layer.
- The `Spire` and `StepCrown` SVG components are reusable — extract as shared icons.
- Status bar (`StatusBar`) and home indicator (`HomeIndicator`) are mock components defined in `_shared.jsx`. In a real iOS app these are system-rendered; in a web wrapper use `env(safe-area-inset-*)`.
- All screen content scrolls inside a fixed-height container with `bottom-nav` floating absolutely. In production, use sticky positioning or a layout container that handles safe areas.
- The original repo's `localStorage` schema should be preserved for backwards compat.

## Assets
No external image assets — all ornament is SVG, all imagery is placeholder (45°-hatched stripe pattern for the exercise-detail demo image). The production app should source real exercise demonstration images/animations.

Fonts loaded from Google Fonts:
- Cinzel: weights 400, 500, 600, 700
- Inter: weights 300, 400, 500, 600, 700
- DM Mono: weights 300, 400, 500
