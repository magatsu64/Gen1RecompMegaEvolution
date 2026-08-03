# Changelog

## 1.3.0

### Added

- Real custom Gen 1-style art for Aerodactyl, Alakazam, Beedrill,
  Blastoise, Blaziken, Charizard X, Charizard Y, Venusaur, Gengar,
  Pinsir, Slowbro, Victreebel, Gyarados, Dragonite, and Pidgeot.
  18 of the 21 forms now have real art; only Starmie, Kangaskhan, and
  Mewtwo X/Y remain placeholder recolors.
- A battle-only `BLAZIKEN_MEGA` record, added to test whether the
  mechanism generalizes to a species outside this mod's real Kanto
  scope. Requires a separate mod providing the real base `BLAZIKEN`
  species -- this mod supplies only the Mega record.

### Fixed

- Several supplied sprites (Pinsir first, then confirmed across the
  whole batch) arrived fully opaque with a solid white background
  baked in, not real alpha transparency -- which is why they were
  rendering oversized (a solid white box, not a character fading into
  the scene). Fixed with a border-flood-fill strip rather than a blanket
  white-to-transparent replace, so legitimate white pixels inside a
  character (eyes, highlights) survive untouched -- only background
  regions connected to the image's edge are removed.

### Removed

- The temporary Blaziken placeholder sprite, now that real art exists
  for it.

## 1.2.1

### Removed

- The Route 1 testing encounter patch (one level-1 wild slot per base
  species). It was only ever there to make every Mega-capable species
  easy to find while testing; not gameplay content.

## 1.2.0

### Added

- Real custom Gen 1-style art for Raichu X, Raichu Y, and Clefable.
  Their back sprites are the traditional half-resolution convention
  (28x28 against a 56x56 front), so unlike the four forms added in
  1.1.0 they need no `battle_sprite_scales` override -- the engine's
  default 2x back-scale already renders them correctly.

## 1.1.2

### Fixed

- The MEGA indicator rendered as two disconnected-looking fragments,
  "ME" on one line and "GA" on the next, because the layout also
  reserved a column for a separate cursor glyph. Dropped the glyph;
  MEGA is one word on one line now, and focus is shown by inverting
  the colors (black-filled background, white text) instead.

## 1.1.1

### Fixed

- The Mega Evolve confirmation box cut off its own text. "MEGA
  EVOLVE?" alone is 96px wide; the box's interior was only 64px.
  Enlarged to 112px of interior width.
- The MEGA indicator moved out of the TYPE/PP box entirely, into the
  blank margin to the left of the move list (confirmed empty in the
  underlying draw code, not shared with any other UI element). It had
  previously sat on the box's top border, which still visually
  touched the border stroke.
- The focus trigger reverted from Up back to Left, matching the
  indicator's new position beside the move list rather than above it.

## 1.1.0

### Added

- Real custom Gen 1-style art for Venusaur, Charizard Y, and Blastoise
  (Charizard X already had real art from the mod this one
  supersedes). All three arrived at full front-matching resolution,
  so each needed a `battle_sprite_scales` override the same way
  Charizard X's did -- without it, the engine's default 2x back-scale
  would render them at double size.

## 1.0.1

### Fixed

- The back sprite rendering at roughly double the correct size. Root
  cause: the back-sprite scale is resolved against the battler's
  *permanent* species, which stays the real base species since this
  mod never touches it -- not the virtual Mega species anything was
  set on. Fixed with an image-path-keyed scale override instead,
  which is checked first regardless of which species record the
  battler's permanent mon points at.

## 1.0.0

First release. Generalizes an earlier single-species proof of concept
(Mega Charizard X only) into all 18 Kanto species with a real Mega
Evolution in Pokemon Legends: Z-A -- 21 forms, since Charizard,
Raichu, and Mewtwo each have two.

- 21 battle-only species records with real Z-A stats and typing.
- A MEGA option on the move-select screen; Charizard/Raichu/Mewtwo get
  an X/Y picker, every other species gets a direct confirm.
- A Mega Evolve flash effect and an HP-bar icon once transformed.
- Placeholder recolors for every form except Charizard X, which had
  real custom art already.
