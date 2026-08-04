# Kanto Mega Evolutions

All 18 Kanto species with a real Mega Evolution in Pokemon Legends:
Z-A (21 forms -- Charizard, Raichu, and Mewtwo each have two). Same
mechanism as the standalone `mega_charizard_x` mod, generalized across
the whole roster, with two changes made by request (see below).

**Supersedes `mega_charizard_x`. Don't run both mods together** -- each
one independently wraps the same `BattleState` functions, and having
both installed would mean whichever loads second wraps the first's
already-wrapped versions, which is not a supported or tested
configuration. Remove `mega_charizard_x` if you're installing this.

**Depends on `fairy_dark_steel_types`** -- Gyarados's Mega form is
Water/Dark and Clefable's is Flying/Fairy, and this engine only has
those types if that mod (built earlier) is also installed.

**Don't want that dependency?** There's a `kanto_mega_evolutions_standalone`
version with no dependencies at all. Gyarados and Clefable keep
vanilla-only typings there instead (Water/Flying and Normal/Flying) --
everything else, including their real stats and sprites, is identical.
Use that one instead if you'd rather not add `fairy_dark_steel_types`.

## The roster and their real Z-A stats

| Species | Form | Type | HP/Atk/Def/Spe (Special*) |
|---|---|---|---|
| Venusaur | -- | Grass/Poison | 80/100/123/80 (121) |
| Charizard | X | Fire/Dragon | 78/130/111/100 (108) |
| Charizard | Y | Fire/Flying | 78/104/78/100 (137) |
| Blastoise | -- | Water | 79/103/120/78 (125) |
| Beedrill | -- | Poison/Bug | 65/150/40/145 (48) |
| Pidgeot | -- | Normal/Flying | 83/80/80/121 (108) |
| Raichu | X | Electric | 60/135/95/110 (93) |
| Raichu | Y | Electric | 60/100/55/130 (120) |
| Alakazam | -- | Psychic | 55/50/65/150 (140) |
| Slowbro | -- | Water/Psychic | 95/75/180/30 (105) |
| Gengar | -- | Poison/Ghost | 60/65/80/130 (133) |
| Victreebel | -- | Grass/Poison | 80/125/85/70 (115) |
| Starmie | -- | Water/Psychic | 60/140/105/120 (118) |
| Clefable | -- | Flying/Fairy | 95/80/93/70 (123) |
| Kangaskhan | -- | Normal | 105/125/100/100 (80) |
| Pinsir | -- | Flying/Bug | 65/155/120/105 (78) |
| Gyarados | -- | Water/Dark | 95/155/109/81 (100) |
| Aerodactyl | -- | Flying/Rock | 80/135/85/150 (83) |
| Dragonite | -- | Flying/Dragon | 91/124/115/100 (135) |
| Mewtwo | X | Fighting/Psychic | 106/190/100/130 (127) |
| Mewtwo | Y | Psychic | 106/150/70/140 (157) |

*Special is the average of Z-A's real Sp. Atk and Sp. Def, since Gen 1
has one unified Special stat rather than a split -- flagged the same
way Charizard X's was, not a real in-game number for any of these.

Stats confirmed against a current, comprehensive Legends: Z-A source
and cross-referenced with Bulbapedia's general Mega Evolution
mechanics page -- these are the Z-A numbers, not the older X/Y/ORAS
ones, since Z-A rebalanced several of these (Charizard X, for
instance, is unchanged, but several others aren't).

**No abilities on any of these** -- and that's not an omission, it
matches the source game: Legends: Z-A removed the ability system
entirely, so Mega Evolution there is pure stat/type change with
nothing to fake or leave out.

## Change 1: the indicator, moved three times, now one word

First drew "MEGA" across the TYPE/PP box's interior, covering the
actual type/PP readout. Moved to a single **M** glyph on the box's
border, then further up above the box, then into the blank margin to
the left of the move list (tile columns 0-3 / rows 13-17, pixel
(0,104)-(32,144) -- confirmed outside both the TYPE/PP box and the
move list box). That version split "MEGA" across two lines, "ME"/"GA",
to leave room for a separate cursor glyph -- which read as two broken
fragments instead of a word. Fixed by dropping the cursor glyph
entirely: **MEGA** is one line now (32px, exactly filling the
available width), and focus is shown by inverting the colors
(black-filled background, white text) instead -- same idea as a
cursor, without needing the extra width a glyph would cost.

## Change 2: the X/Y picker box, enlarged

For Charizard, Raichu, and Mewtwo, pressing A on the indicator opens a
second, temporary box asking **X** or **Y** (Up/Down to choose, A to
confirm, B to cancel back). Every other species gets a direct confirm
box (A: yes, B: no) instead.

The box was cutting text off before: "MEGA EVOLVE?" alone is 12 glyphs
= 96px, wider than the old box's entire 64px interior. Enlarged from
tile (5,3) size (10,6) to tile (2,2) size (16,7) -- pixel (16,16) to
(144,72), 112px of interior width -- comfortably fitting both
"MEGA EVOLVE?" (96px) and "A:YES  B:NO" (88px) with room left over.
Still only on screen while actively choosing, closing the instant a
choice is confirmed or B is pressed.

## Controls

- **Left** from the move list: focus the MEGA indicator (back to this,
  from the brief Up-based version -- the indicator no longer shares
  space with the TYPE/PP box, so there's no longer a reason for the
  Up-from-top-slot workaround that needed).
- **A** while focused: open the Mega Evolve box.
- In that box: **Up/Down** to pick X or Y (dual-form species only),
  **A** to confirm, **B** to back out without transforming.
- **Right** or **B** on the indicator itself (box not open): back to
  the move list, unchanged.

## The art (mostly real now)

Only 4 of the 21 forms are still recolors of each species' own real
vanilla battle sprite (`transforms.lua`): Starmie, Kangaskhan, and
Mewtwo X/Y. Most real Mega forms have genuine shape changes -- extra
limbs, wings, armor plating -- that a palette shift can't produce;
these four are a disclosed placeholder, the same tradeoff every other
species had before their real art arrived. The other 17 (Venusaur,
Charizard X, Charizard Y, Blastoise, Beedrill, Pidgeot, Raichu X,
Raichu Y, Alakazam, Slowbro, Gengar, Victreebel, Clefable, Pinsir,
Gyarados, Aerodactyl, Dragonite) all have real custom art now.

(21 minus 4 placeholder is 17, not 18 -- an earlier changelog entry
says 18, which was an arithmetic slip; left as historical record there
rather than edited after the fact, corrected here where it counts.)

Real source filenames confirmed per species against
`tools/rom_manifest.json`'s `pokemonAssets` table, not assumed from a
naming pattern -- every back-sprite slug turned out to be the front
slug plus `"b"` (`beedrillb`, `pidgeotb`, etc.), confirmed for each
remaining recolored species individually rather than assumed to hold
universally after Charizard's own case (`charizard`/`charizardb`)
matched it.

**Two different real-art sizes, handled differently, not the same fix
applied blindly twice.** Charizard X/Y, Venusaur, Blastoise, Beedrill,
Alakazam, Slowbro, Gengar, Pinsir, Aerodactyl, Blaziken, and Gyarados
all arrived at full front-matching resolution (56x56 back sprites, not
the traditional half-size) and need the `battle_sprite_scales`
override (`fullResBack = true` in the data table). Raichu X/Y and
Clefable's back sprites arrived at 28x28 -- exactly half of their
56x56 fronts, the *traditional* Gen 1 back-sprite convention -- so
those get the engine's normal default 2x back-scale like a recolor
would, no override at all. Checked each one's actual pixel dimensions
before deciding, rather than assuming every piece of custom art needs
the same treatment.

None of the 4 remaining recolors needed a `battle_sprite_scales`
override either, for the same reason as Raichu/Clefable: a recolor
doesn't resize the image, so each one is still the exact pixel
dimensions of its vanilla source, which the engine's default 2x
back-scale already renders correctly.

## What's deliberately not here ("the rest," still)

- **No real Mega Stone trigger** -- same reason as `mega_charizard_x`:
  this engine has no held-item system at all.
- **No abilities** -- matches the source game (Z-A has none), not a gap.
- **Enemy trainers never Mega Evolve** -- the override only ever looks
  at `battle.player`.
- **catchRate/baseExp/growthRate/level1Moves** are uniform placeholders
  across all 21 real Kanto forms (45 / 200 / MEDIUM_SLOW / Tackle) --
  not researched per species, since none of these fields are ever read
  for a species that's never caught, leveled up, or taught a move here.

## Beyond Kanto: 54 data-only species (not usable yet)

This mod also carries Mega records for 54 species outside the real
Kanto scope above -- the rest of the real X/Y, ORAS, and Z-A roster
(Blaziken, Meganium, Feraligatr, Ampharos, Tyranitar, Garchomp,
Lucario, Rayquaza, and many more). These are fundamentally different
from the 21 Kanto forms above:

- **No base species.** This engine only has Kanto (dex 1-151) built
  in. None of these 54 species exist here at all without a separate
  mod providing the real base species first (see `blaziken_kanto` for
  an example of exactly that, built specifically to test this).
- **No real art.** All 54 share one placeholder image
  (`assets/dataonly_placeholder.png`), except Blaziken, which has real
  supplied art.
- **Stats and typing are real**, checked directly against real stats
  tables rather than invented -- these aren't guesses, just untestable
  without a base species to attach them to.
- **Not a complete implementation.** No real movesets (would mean
  inventing dozens of moves that don't exist in Gen 1 at all -- a much
  bigger separate project), and typing for species that need Fairy,
  Steel, or Dark falls back to a same-shape substitute in the
  standalone version, the same way Gyarados/Clefable do above.

## Credits for the real art

Traced back at your request, since you weren't sure of the exact
sources. Confidence varies per artist -- noted honestly rather than
presented as uniformly certain:

- **Charizard Y, Blastoise**: [Solo993 on DeviantArt](https://www.deviantart.com/solo993/art/Mega-Charizard-Y-and-Mega-Blastoise-gbc-sprite-423072991)
  (2013). The page itself is confirmed real and locatable. **License
  unconfirmed** -- I couldn't find explicit usage terms on the post
  itself from what I could retrieve. Worth checking that page directly
  before relying on it; a 2013 DeviantArt post with no stated license
  typically defaults to all-rights-reserved rather than free-use.
- **Venusaur, Charizard X**: [BouncingPiplup on DeviantArt](https://www.deviantart.com/bouncingpiplup),
  from their ongoing "G1SP" (Gen 1 Style Project) series -- a
  systematic, currently-active effort to draw every Pokemon in genuine
  Gen 1 sprite format. Explicitly licensed **Creative Commons
  Attribution-ShareAlike 3.0** (confirmed stated directly on multiple
  pieces in the series).
- **Clefable, Raichu X/Y**: [FrenchOrange on DeviantArt](https://www.deviantart.com/frenchorange).
  Multiple of their pieces explicitly state **"free to use as long as
  proper credit is given"** in the artist's own words, confirmed
  directly on several posts.

## Files

- `manifest.json` -- declares `engine_internals`, `assets_transforms`,
  and the `fairy_dark_steel_types` dependency
- `main.lua` -- all 21 real Kanto species records, the 54 data-only
  non-Kanto records, the generalized `BattleState.update`/
  `drawTextArea`/`draw` wraps, and the `SummaryMenu.new`/`draw` wraps
  for the mid-battle stats screen
- `transforms.lua` -- the 4 remaining recolor recipes (front+back per
  form: Starmie, Kangaskhan, Mewtwo X, Mewtwo Y)
- `assets/` -- 36 real art files (17 Kanto forms + Blaziken, 18
  species total, front and back each) plus one shared placeholder
  image for the other 53 data-only species (37 files total)
