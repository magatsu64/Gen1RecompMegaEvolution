-- mods/kanto_mega_evolutions/main.lua
--
-- Generalizes the single-species mega_charizard_x mechanism (same repo,
-- earlier mod -- superseded by this one; don't run both together, they'd
-- each wrap the same BattleState functions independently and conflict)
-- across all 18 Kanto species with a real Mega Evolution in Pokemon
-- Legends Z-A. Same `engine_internals` override technique, same reasons
-- (no hook exists for adding a menu option to the battle screen -- see
-- mega_charizard_x's README for the full source-level justification,
-- unchanged here).
--
-- Two changes from that mod, both by request:
-- 1. The MEGA indicator moved off the TYPE/PP box's readout rows (see
--    section 3 below) so it no longer competes with the type/PP text.
-- 2. Charizard, Mewtwo, and Raichu each have two forms (X/Y) -- pressing
--    A on the indicator now opens a second, dedicated box asking which,
--    instead of assuming one.
--
-- Stats are real, from Pokemon Legends Z-A (checked against a current,
-- comprehensive source, cross-referenced with Bulbapedia's general
-- Mega Evolution mechanics page) -- not the older X/Y/ORAS numbers,
-- since Z-A rebalanced several of these. Z-A also has no ability
-- system at all, which is why none of these forms have one either --
-- that's not an omission, it matches the source game.
--
-- Special is one stat here (Gen 1 has no Sp.Atk/Sp.Def split): every
-- form's Special is the average of Z-A's real Sp. Atk and Sp. Def,
-- rounded -- not a real Gen-1-era number for any of these, flagged the
-- same way Charizard X's was.
--
-- ART, as agreed: placeholder recolors of each species' own vanilla
-- battle sprite (transforms.lua) for everything except Charizard X,
-- which keeps the real custom art supplied earlier. Most real Mega
-- designs have genuine shape changes a recolor can't capture -- this
-- is a disclosed placeholder, not a claim of accuracy.

return function(mod)

  ------------------------------------------------------------------
  -- 1. All 18 species, each either one form or an X/Y pair. dex reuses
  -- each real species' own vanilla dex number (same reasoning as
  -- mega_charizard_x: these are battle-only lookup records, never
  -- placed in a party/dex/encounter table, so this doesn't inflate the
  -- in-game Pokedex size the way a fresh high number would).
  --
  -- catchRate/baseExp/growthRate/level1Moves are uniform placeholders
  -- (45 / 200 / MEDIUM_SLOW / TACKLE) across every form -- deliberately
  -- not researched per species, since none of these fields are ever
  -- read for a species that's never caught, leveled, or taught a move.
  ------------------------------------------------------------------
  local MEGA_FORMS = {
    VENUSAUR = { kind = "single", id = "VENUSAUR_MEGA", dex = 3,
      types = { "GRASS", "POISON" },
      stats = { hp = 80, attack = 100, defense = 123, speed = 80, special = 121 },
      customArt = { front = "assets/venusaur_front.png", back = "assets/venusaur_back.png", fullResBack = true } },
    CHARIZARD = { kind = "dual",
      x = { id = "CHARIZARD_MEGA_X", dex = 6, types = { "FIRE", "DRAGON" },
        stats = { hp = 78, attack = 130, defense = 111, speed = 100, special = 108 },
        customArt = { front = "assets/charizard_x_front.png", back = "assets/charizard_x_back.png", fullResBack = true } },
      y = { id = "CHARIZARD_MEGA_Y", dex = 6, types = { "FIRE", "FLYING" },
        stats = { hp = 78, attack = 104, defense = 78, speed = 100, special = 137 },
        customArt = { front = "assets/charizard_y_front.png", back = "assets/charizard_y_back.png", fullResBack = true } } },
    BLASTOISE = { kind = "single", id = "BLASTOISE_MEGA", dex = 9,
      types = { "WATER" },
      stats = { hp = 79, attack = 103, defense = 120, speed = 78, special = 125 },
      customArt = { front = "assets/blastoise_front.png", back = "assets/blastoise_back.png", fullResBack = true } },
    BEEDRILL = { kind = "single", id = "BEEDRILL_MEGA", dex = 15,
      types = { "POISON", "BUG" },
      stats = { hp = 65, attack = 150, defense = 40, speed = 145, special = 48 },
      customArt = { front = "assets/beedrill_front.png", back = "assets/beedrill_back.png", fullResBack = true } },
    PIDGEOT = { kind = "single", id = "PIDGEOT_MEGA", dex = 18,
      types = { "NORMAL", "FLYING" },
      stats = { hp = 83, attack = 80, defense = 80, speed = 121, special = 108 },
      customArt = { front = "assets/pidgeot_front.png", back = "assets/pidgeot_back.png", fullResBack = true } },
    RAICHU = { kind = "dual",
      x = { id = "RAICHU_MEGA_X", dex = 26, types = { "ELECTRIC" },
        stats = { hp = 60, attack = 135, defense = 95, speed = 110, special = 93 },
        customArt = { front = "assets/raichu_x_front.png", back = "assets/raichu_x_back.png" } },
      y = { id = "RAICHU_MEGA_Y", dex = 26, types = { "ELECTRIC" },
        stats = { hp = 60, attack = 100, defense = 55, speed = 130, special = 120 },
        customArt = { front = "assets/raichu_y_front.png", back = "assets/raichu_y_back.png" } } },
    ALAKAZAM = { kind = "single", id = "ALAKAZAM_MEGA", dex = 65,
      types = { "PSYCHIC" },
      stats = { hp = 55, attack = 50, defense = 65, speed = 150, special = 140 },
      customArt = { front = "assets/alakazam_front.png", back = "assets/alakazam_back.png", fullResBack = true } },
    SLOWBRO = { kind = "single", id = "SLOWBRO_MEGA", dex = 80,
      types = { "WATER", "PSYCHIC" },
      stats = { hp = 95, attack = 75, defense = 180, speed = 30, special = 105 },
      customArt = { front = "assets/slowbro_front.png", back = "assets/slowbro_back.png", fullResBack = true } },
    GENGAR = { kind = "single", id = "GENGAR_MEGA", dex = 94,
      types = { "POISON", "GHOST" },
      stats = { hp = 60, attack = 65, defense = 80, speed = 130, special = 133 },
      customArt = { front = "assets/gengar_front.png", back = "assets/gengar_back.png", fullResBack = true } },
    VICTREEBEL = { kind = "single", id = "VICTREEBEL_MEGA", dex = 71,
      types = { "GRASS", "POISON" },
      stats = { hp = 80, attack = 125, defense = 85, speed = 70, special = 115 },
      customArt = { front = "assets/victreebel_front.png", back = "assets/victreebel_back.png", fullResBack = true } },
    STARMIE = { kind = "single", id = "STARMIE_MEGA", dex = 121,
      types = { "WATER", "PSYCHIC" },
      stats = { hp = 60, attack = 140, defense = 105, speed = 120, special = 118 },
      artPrefix = "starmie_mega" },
    -- FAIRY -- confirmed dependency on fairy_dark_steel_types below.
    CLEFABLE = { kind = "single", id = "CLEFABLE_MEGA", dex = 36,
      types = { "FLYING", "FAIRY" },
      stats = { hp = 95, attack = 80, defense = 93, speed = 70, special = 123 },
      customArt = { front = "assets/clefable_front.png", back = "assets/clefable_back.png" } },
    KANGASKHAN = { kind = "single", id = "KANGASKHAN_MEGA", dex = 115,
      types = { "NORMAL" },
      stats = { hp = 105, attack = 125, defense = 100, speed = 100, special = 80 },
      artPrefix = "kangaskhan_mega" },
    PINSIR = { kind = "single", id = "PINSIR_MEGA", dex = 127,
      types = { "FLYING", "BUG" },
      stats = { hp = 65, attack = 155, defense = 120, speed = 105, special = 78 },
      -- Real art, user-supplied with permission. Back sprite is 48x48
      -- (the real Gen 2 Gold/Silver back-sprite convention, before
      -- Gen 3+ standardized to 56x56) -- close to full size rather
      -- than genuinely half-resolution, so it needs fullResBack the
      -- same as every other full/near-full-resolution custom art here,
      -- or the engine's default 2x back-scale would double it to 96x96
      -- against a 56x56 front.
      customArt = { front = "assets/pinsir_front.png", back = "assets/pinsir_back.png", fullResBack = true } },
    -- DARK -- confirmed dependency on fairy_dark_steel_types below.
    GYARADOS = { kind = "single", id = "GYARADOS_MEGA", dex = 130,
      types = { "WATER", "DARK" },
      stats = { hp = 95, attack = 155, defense = 109, speed = 81, special = 100 },
      customArt = { front = "assets/gyarados_front.png", back = "assets/gyarados_back.png", fullResBack = true } },
    AERODACTYL = { kind = "single", id = "AERODACTYL_MEGA", dex = 142,
      types = { "FLYING", "ROCK" },
      stats = { hp = 80, attack = 135, defense = 85, speed = 150, special = 83 },
      customArt = { front = "assets/aerodactyl_front.png", back = "assets/aerodactyl_back.png", fullResBack = true } },
    DRAGONITE = { kind = "single", id = "DRAGONITE_MEGA", dex = 149,
      types = { "FLYING", "DRAGON" },
      stats = { hp = 91, attack = 124, defense = 115, speed = 100, special = 135 },
      customArt = { front = "assets/dragonite_front.png", back = "assets/dragonite_back.png", fullResBack = true } },
    MEWTWO = { kind = "dual",
      x = { id = "MEWTWO_MEGA_X", dex = 150, types = { "FIGHTING", "PSYCHIC" },
        stats = { hp = 106, attack = 190, defense = 100, speed = 130, special = 127 },
        artPrefix = "mewtwo_mega_x" },
      y = { id = "MEWTWO_MEGA_Y", dex = 150, types = { "PSYCHIC" },
        stats = { hp = 106, attack = 150, defense = 70, speed = 140, special = 157 },
        artPrefix = "mewtwo_mega_y" } },

    -- Not a real Kanto Mega: Blaziken is Gen 3 (Hoenn), not Gen 1, so
    -- it isn't part of this mod's actual scope. A separate mod
    -- provides the real base BLAZIKEN species -- this mod only
    -- supplies the Mega record, the same pattern used for every other
    -- species here, and depends on that other mod for the base species
    -- to exist first.
    --
    -- Real stats, verified: Mega Blaziken HP 80/Atk 160/Def 80/
    -- SpA 130/SpD 80/Spe 100 (BST 630, checked against base Blaziken's
    -- real 530 BST and confirmed the delta matches exactly). Special
    -- here is the same average-of-SpA/SpD approximation used for every
    -- other form: (130+80)/2 = 105.
    BLAZIKEN = { kind = "single", id = "BLAZIKEN_MEGA", dex = 257,
      types = { "FIRE", "FIGHTING" },
      stats = { hp = 80, attack = 160, defense = 80, speed = 100, special = 105 },
      -- Real art now supplied -- no longer the placeholder.
      customArt = { front = "assets/blaziken_front.png", back = "assets/blaziken_back.png", fullResBack = true } },

    -- ------------------------------------------------------------------
    -- DATA ONLY, non-Kanto: same status as BLAZIKEN above -- these are
    -- battle-only lookup records for species outside this mod's real
    -- Kanto scope. None of them are usable or testable without a
    -- separate mod providing their real base species first (this
    -- engine is Kanto-only, dex 1-151, so none of these exist here at
    -- all otherwise). No art for any of them yet either.
    --
    -- Stats verified against a real leaked-stats source, not invented
    -- -- checked directly, not from memory. Special is the same
    -- average-of-real-Sp.Atk/Sp.Def approximation used throughout this
    -- mod. Typing is each species' real vanilla typing unless the
    -- source specifically states a change (noted per entry).
    --
    -- level1Moves is one thematically-fitting move that already exists
    -- in vanilla Gen 1 -- NOT these species' real Z-A movesets. A real
    -- moveset for most of these would need moves invented from scratch
    -- (Play Rough, Iron Head, Dragon Claw, etc. don't exist in Gen 1 at
    -- all), the same undertaking the original Alolan Vulpix mod needed
    -- for its own new moves -- a separate, larger project than this
    -- data-only pass.
    --
    -- DEPENDENCY VERSION ONLY: 7 of these need FAIRY, STEEL, or DARK
    -- (already available here via fairy_dark_steel_types) -- flagged
    -- per entry. The standalone version needs the same kind of typing
    -- fallback Gyarados/Clefable got there, not yet applied to these.
    -- ------------------------------------------------------------------
    MEGANIUM = { kind = "single", id = "MEGANIUM_MEGA", dex = 154,
      -- Needs FAIRY.
      types = { "GRASS", "FAIRY" },
      stats = { hp = 80, attack = 92, defense = 115, speed = 80, special = 129 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    FERALIGATR = { kind = "single", id = "FERALIGATR_MEGA", dex = 160,
      types = { "WATER", "DRAGON" },
      stats = { hp = 85, attack = 160, defense = 125, speed = 78, special = 91 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    SKARMORY = { kind = "single", id = "SKARMORY_MEGA", dex = 227,
      -- Needs STEEL.
      types = { "STEEL", "FLYING" },
      stats = { hp = 65, attack = 140, defense = 110, speed = 110, special = 70 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    FROSLASS = { kind = "single", id = "FROSLASS_MEGA", dex = 478,
      types = { "ICE", "GHOST" },
      stats = { hp = 70, attack = 80, defense = 70, speed = 120, special = 120 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    EMBOAR = { kind = "single", id = "EMBOAR_MEGA", dex = 500,
      types = { "FIRE", "FIGHTING" },
      stats = { hp = 110, attack = 148, defense = 75, speed = 75, special = 110 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    EXCADRILL = { kind = "single", id = "EXCADRILL_MEGA", dex = 530,
      -- Needs STEEL.
      types = { "GROUND", "STEEL" },
      stats = { hp = 110, attack = 164, defense = 100, speed = 103, special = 65 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    SCOLIPEDE = { kind = "single", id = "SCOLIPEDE_MEGA", dex = 545,
      types = { "BUG", "POISON" },
      stats = { hp = 60, attack = 140, defense = 149, speed = 62, special = 87 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    SCRAFTY = { kind = "single", id = "SCRAFTY_MEGA", dex = 560,
      -- Needs DARK.
      types = { "DARK", "FIGHTING" },
      stats = { hp = 65, attack = 130, defense = 135, speed = 68, special = 95 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    EELEKTROSS = { kind = "single", id = "EELEKTROSS_MEGA", dex = 604,
      types = { "ELECTRIC" },
      stats = { hp = 85, attack = 145, defense = 80, speed = 80, special = 113 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    CHANDELURE = { kind = "single", id = "CHANDELURE_MEGA", dex = 609,
      types = { "GHOST", "FIRE" },
      stats = { hp = 60, attack = 75, defense = 110, speed = 90, special = 143 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    CHESNAUGHT = { kind = "single", id = "CHESNAUGHT_MEGA", dex = 652,
      types = { "GRASS", "FIGHTING" },
      stats = { hp = 88, attack = 137, defense = 172, speed = 44, special = 95 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    DELPHOX = { kind = "single", id = "DELPHOX_MEGA", dex = 655,
      types = { "FIRE", "PSYCHIC" },
      stats = { hp = 75, attack = 69, defense = 72, speed = 134, special = 142 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    GRENINJA = { kind = "single", id = "GRENINJA_MEGA", dex = 658,
      -- Needs DARK.
      types = { "WATER", "DARK" },
      stats = { hp = 72, attack = 125, defense = 77, speed = 142, special = 107 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    PYROAR = { kind = "single", id = "PYROAR_MEGA", dex = 668,
      types = { "FIRE", "NORMAL" },
      stats = { hp = 88, attack = 88, defense = 92, speed = 126, special = 108 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    MALAMAR = { kind = "single", id = "MALAMAR_MEGA", dex = 687,
      -- Needs DARK.
      types = { "DARK", "PSYCHIC" },
      stats = { hp = 86, attack = 102, defense = 88, speed = 88, special = 109 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    BARBARACLE = { kind = "single", id = "BARBARACLE_MEGA", dex = 690,
      -- Real type change -- sheds Water entirely, becomes Rock/Fighting.
      types = { "ROCK", "FIGHTING" },
      stats = { hp = 72, attack = 140, defense = 130, speed = 88, special = 85 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    DRAGALGE = { kind = "single", id = "DRAGALGE_MEGA", dex = 691,
      types = { "POISON", "DRAGON" },
      stats = { hp = 65, attack = 85, defense = 105, speed = 44, special = 148 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    HAWLUCHA = { kind = "single", id = "HAWLUCHA_MEGA", dex = 701,
      types = { "FIGHTING", "FLYING" },
      stats = { hp = 78, attack = 137, defense = 100, speed = 118, special = 84 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    FLOETTE_ETERNAL = { kind = "single", id = "FLOETTE_ETERNAL_MEGA", dex = 670,
      -- Needs FAIRY. Eternal Flower Floette, a special form, not
      -- regular Floette -- keeps its solo Fairy typing on Mega Evolving.
      types = { "FAIRY" },
      stats = { hp = 74, attack = 85, defense = 87, speed = 102, special = 152 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    DRAMPA = { kind = "single", id = "DRAMPA_MEGA", dex = 780,
      types = { "NORMAL", "DRAGON" },
      stats = { hp = 78, attack = 85, defense = 110, speed = 36, special = 138 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    FALINKS = { kind = "single", id = "FALINKS_MEGA", dex = 870,
      types = { "FIGHTING" },
      stats = { hp = 65, attack = 135, defense = 135, speed = 100, special = 68 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    ZYGARDE_COMPLETE = { kind = "single", id = "ZYGARDE_COMPLETE_MEGA", dex = 718,
      types = { "DRAGON", "GROUND" },
      stats = { hp = 216, attack = 70, defense = 91, speed = 100, special = 151 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },

    -- ------------------------------------------------------------------
    -- DATA ONLY, X/Y and ORAS roster. Same status as everything above:
    -- no art, no base species, untestable without a separate mod. Real
    -- per-stat data checked directly against a real stats table (not
    -- totals-only), so Special here is a genuine average of each
    -- species' own real Sp.Atk/Sp.Def, not estimated from a total.
    -- ------------------------------------------------------------------
    AMPHAROS = { kind = "single", id = "AMPHAROS_MEGA", dex = 181,
      types = { "ELECTRIC", "DRAGON" },
      stats = { hp = 90, attack = 95, defense = 105, speed = 45, special = 138 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    STEELIX = { kind = "single", id = "STEELIX_MEGA", dex = 208,
      -- Needs STEEL.
      types = { "STEEL", "GROUND" },
      stats = { hp = 75, attack = 125, defense = 230, speed = 30, special = 75 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    SCIZOR = { kind = "single", id = "SCIZOR_MEGA", dex = 212,
      -- Needs STEEL.
      types = { "BUG", "STEEL" },
      stats = { hp = 70, attack = 150, defense = 140, speed = 75, special = 83 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    HERACROSS = { kind = "single", id = "HERACROSS_MEGA", dex = 214,
      types = { "BUG", "FIGHTING" },
      stats = { hp = 80, attack = 185, defense = 115, speed = 75, special = 73 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    HOUNDOOM = { kind = "single", id = "HOUNDOOM_MEGA", dex = 229,
      -- Needs DARK.
      types = { "DARK", "FIRE" },
      stats = { hp = 75, attack = 90, defense = 90, speed = 115, special = 115 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    TYRANITAR = { kind = "single", id = "TYRANITAR_MEGA", dex = 248,
      -- Needs DARK.
      types = { "ROCK", "DARK" },
      stats = { hp = 100, attack = 164, defense = 150, speed = 71, special = 108 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    SCEPTILE = { kind = "single", id = "SCEPTILE_MEGA", dex = 254,
      types = { "GRASS", "DRAGON" },
      stats = { hp = 70, attack = 110, defense = 75, speed = 145, special = 115 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    SWAMPERT = { kind = "single", id = "SWAMPERT_MEGA", dex = 260,
      types = { "WATER", "GROUND" },
      stats = { hp = 100, attack = 150, defense = 110, speed = 70, special = 103 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    GARDEVOIR = { kind = "single", id = "GARDEVOIR_MEGA", dex = 282,
      -- Needs FAIRY.
      types = { "PSYCHIC", "FAIRY" },
      stats = { hp = 68, attack = 85, defense = 65, speed = 100, special = 150 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    SABLEYE = { kind = "single", id = "SABLEYE_MEGA", dex = 302,
      -- Needs DARK.
      types = { "DARK", "GHOST" },
      stats = { hp = 50, attack = 85, defense = 125, speed = 20, special = 100 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    MAWILE = { kind = "single", id = "MAWILE_MEGA", dex = 303,
      -- Needs STEEL and FAIRY.
      types = { "STEEL", "FAIRY" },
      stats = { hp = 50, attack = 105, defense = 125, speed = 50, special = 75 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    AGGRON = { kind = "single", id = "AGGRON_MEGA", dex = 306,
      -- Needs STEEL.
      types = { "STEEL" },
      stats = { hp = 70, attack = 140, defense = 230, speed = 50, special = 70 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    MEDICHAM = { kind = "single", id = "MEDICHAM_MEGA", dex = 308,
      types = { "FIGHTING", "PSYCHIC" },
      stats = { hp = 60, attack = 100, defense = 85, speed = 100, special = 83 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    MANECTRIC = { kind = "single", id = "MANECTRIC_MEGA", dex = 310,
      types = { "ELECTRIC" },
      stats = { hp = 70, attack = 75, defense = 80, speed = 135, special = 108 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    SHARPEDO = { kind = "single", id = "SHARPEDO_MEGA", dex = 319,
      -- Needs DARK.
      types = { "WATER", "DARK" },
      stats = { hp = 70, attack = 140, defense = 70, speed = 105, special = 88 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    CAMERUPT = { kind = "single", id = "CAMERUPT_MEGA", dex = 323,
      types = { "FIRE", "GROUND" },
      stats = { hp = 70, attack = 120, defense = 100, speed = 20, special = 125 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    ALTARIA = { kind = "single", id = "ALTARIA_MEGA", dex = 334,
      -- Needs FAIRY.
      types = { "DRAGON", "FAIRY" },
      stats = { hp = 75, attack = 110, defense = 110, speed = 80, special = 108 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    BANETTE = { kind = "single", id = "BANETTE_MEGA", dex = 354,
      types = { "GHOST" },
      stats = { hp = 64, attack = 165, defense = 75, speed = 75, special = 88 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    ABSOL = { kind = "single", id = "ABSOL_MEGA", dex = 359,
      -- Needs DARK.
      types = { "DARK" },
      stats = { hp = 65, attack = 150, defense = 60, speed = 115, special = 88 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    GLALIE = { kind = "single", id = "GLALIE_MEGA", dex = 362,
      types = { "ICE" },
      stats = { hp = 80, attack = 120, defense = 80, speed = 100, special = 100 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    SALAMENCE = { kind = "single", id = "SALAMENCE_MEGA", dex = 373,
      types = { "DRAGON", "FLYING" },
      stats = { hp = 95, attack = 145, defense = 130, speed = 120, special = 105 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    METAGROSS = { kind = "single", id = "METAGROSS_MEGA", dex = 376,
      -- Needs STEEL.
      types = { "STEEL", "PSYCHIC" },
      stats = { hp = 80, attack = 145, defense = 150, speed = 110, special = 108 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    LATIAS = { kind = "single", id = "LATIAS_MEGA", dex = 380,
      types = { "DRAGON", "PSYCHIC" },
      stats = { hp = 80, attack = 100, defense = 120, speed = 110, special = 145 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    LATIOS = { kind = "single", id = "LATIOS_MEGA", dex = 381,
      types = { "DRAGON", "PSYCHIC" },
      stats = { hp = 80, attack = 130, defense = 100, speed = 110, special = 140 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    RAYQUAZA_MEGA_SP = { kind = "single", id = "RAYQUAZA_MEGA", dex = 384,
      types = { "DRAGON", "FLYING" },
      stats = { hp = 105, attack = 180, defense = 100, speed = 115, special = 140 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    LOPUNNY = { kind = "single", id = "LOPUNNY_MEGA", dex = 428,
      types = { "NORMAL", "FIGHTING" },
      stats = { hp = 65, attack = 136, defense = 94, speed = 135, special = 75 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    GARCHOMP = { kind = "single", id = "GARCHOMP_MEGA", dex = 445,
      types = { "DRAGON", "GROUND" },
      stats = { hp = 108, attack = 170, defense = 115, speed = 92, special = 108 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    LUCARIO = { kind = "single", id = "LUCARIO_MEGA", dex = 448,
      -- Needs STEEL.
      types = { "FIGHTING", "STEEL" },
      stats = { hp = 70, attack = 145, defense = 88, speed = 112, special = 105 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    ABOMASNOW = { kind = "single", id = "ABOMASNOW_MEGA", dex = 460,
      types = { "GRASS", "ICE" },
      stats = { hp = 90, attack = 132, defense = 105, speed = 30, special = 119 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    GALLADE = { kind = "single", id = "GALLADE_MEGA", dex = 475,
      types = { "PSYCHIC", "FIGHTING" },
      stats = { hp = 68, attack = 165, defense = 95, speed = 110, special = 90 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    AUDINO = { kind = "single", id = "AUDINO_MEGA", dex = 531,
      -- Needs FAIRY.
      types = { "NORMAL", "FAIRY" },
      stats = { hp = 103, attack = 60, defense = 126, speed = 50, special = 103 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
    DIANCIE = { kind = "single", id = "DIANCIE_MEGA", dex = 719,
      -- Needs FAIRY.
      types = { "ROCK", "FAIRY" },
      stats = { hp = 50, attack = 160, defense = 110, speed = 110, special = 135 },
      customArt = { front = "assets/dataonly_placeholder.png", back = "assets/dataonly_placeholder.png" } },
  }

  ------------------------------------------------------------------
  -- 1b. Registration. One helper for both single and dual entries, so
  -- the shape of the table above stays declarative rather than mixing
  -- registration calls into it.
  ------------------------------------------------------------------
  local function registerForm(baseName, form)
    local spriteFront, spriteBack
    if form.customArt then
      spriteFront = mod.assets:path(form.customArt.front)
      spriteBack = mod.assets:path(form.customArt.back)
    else
      spriteFront = "save/mod-derived/kanto_mega_evolutions/battle/front/" .. form.artPrefix .. ".png"
      spriteBack = "save/mod-derived/kanto_mega_evolutions/battle/back/" .. form.artPrefix .. ".png"
    end
    mod.content.pokemon:register(form.id, {
      id = form.id, name = baseName, dex = form.dex,
      types = form.types, baseStats = form.stats,
      catchRate = 45, baseExp = 200, growthRate = "MEDIUM_SLOW",
      level1Moves = { "TACKLE" }, learnset = {}, evolutions = {},
      spriteFront = spriteFront, spriteBack = spriteBack,
      frontSize = 7, trueColor = true,
    })
    -- Only full-resolution custom art needs a scale override (see
    -- mega_charizard_x's README for the full explanation): that art is
    -- front-matching resolution, not the traditional half-resolution
    -- back sprite the engine expects to double. Explicit opt-in
    -- (form.customArt.fullResBack) rather than "any custom art" now --
    -- Raichu X/Y's and Clefable's back sprites came in at 28x28, half
    -- of their 56x56 fronts, the traditional convention, so those get
    -- the engine's normal default 2x scale like a recolor would, same
    -- as the 17 recolors below need no override at all.
    if form.customArt and form.customArt.fullResBack then
      mod.content.battle_sprite_scales:register(form.id .. "_back", {
        path = spriteBack, scale = 1,
      })
    end
  end

  for baseName, entry in pairs(MEGA_FORMS) do
    if entry.kind == "single" then
      registerForm(baseName, entry)
    else
      registerForm(baseName, entry.x)
      registerForm(baseName, entry.y)
    end
  end

  ------------------------------------------------------------------
  -- 2. The override -- same technique as mega_charizard_x, generalized.
  ------------------------------------------------------------------
  local BattleState = require("src.battle.BattleState")
  local Stats = require("src.pokemon.Stats")
  local Font = require("src.render.Font")
  local Strings = require("src.core.Strings")

  local function megaEligible(battle)
    return battle.phase == "moveSelect"
       and battle.player and battle.player.mon
       and MEGA_FORMS[battle.player.mon.species] ~= nil
       and not battle.player.megaActive
  end

  local function applyMegaEvolution(battle, form)
    local newDef = mod.content.pokemon:get(form.id)
    if not newDef then return end
    local mon = battle.player.mon
    battle.player.curStats = Stats.calc(newDef, mon.level, mon.dvs, mon.statExp)
    battle.player.curTypes = newDef.types
    battle.player.sprite = battle:speciesSprite(form.id, true)
    battle.player.megaActive = true
    -- Tracks exactly which form (X/Y/single) is active, since MEGA_FORMS
    -- is keyed by base species and dual entries hold both X and Y --
    -- needed below so the summary screen patch knows which one's sprite
    -- and stats to show, not just "is mega active" as a bare flag.
    battle.player.megaFormId = form.id
    battle.megaFlashTimer = 30
  end

  ------------------------------------------------------------------
  -- 2a. Input. Same phase-swap wrap technique as mega_charizard_x (see
  -- that mod's comments for the full reasoning) -- extended with a
  -- second input state, megaPickerOpen, for the X/Y (or confirm) box.
  ------------------------------------------------------------------
  local originalUpdate = BattleState.update
  function BattleState:update(dt)
    if self.megaFlashTimer and self.megaFlashTimer > 0 then
      self.megaFlashTimer = self.megaFlashTimer - 1
    end
    if megaEligible(self) then
      local input = self.game.input
      local entry = MEGA_FORMS[self.player.mon.species]
      if self.megaPickerOpen then
        if entry.kind == "dual" then
          if input:wasPressed("up") or input:wasPressed("down") then
            self.megaPickerIndex = self.megaPickerIndex == 1 and 2 or 1
          elseif input:wasPressed("a") then
            applyMegaEvolution(self, self.megaPickerIndex == 1 and entry.x or entry.y)
            self.megaPickerOpen = false
            self.megaFocused = false
          elseif input:wasPressed("b") then
            self.megaPickerOpen = false
          end
        else
          if input:wasPressed("a") then
            applyMegaEvolution(self, entry)
            self.megaPickerOpen = false
            self.megaFocused = false
          elseif input:wasPressed("b") then
            self.megaPickerOpen = false
          end
        end
        local realPhase = self.phase
        self.phase = "__kme_focus__"
        originalUpdate(self, dt)
        self.phase = realPhase
        return
      elseif self.megaFocused then
        if input:wasPressed("a") then
          self.megaPickerOpen = true
          self.megaPickerIndex = 1
        elseif input:wasPressed("right") or input:wasPressed("b") then
          self.megaFocused = false
        end
        local realPhase = self.phase
        self.phase = "__kme_focus__"
        originalUpdate(self, dt)
        self.phase = realPhase
        return
      -- Back to LEFT, as originally, and as asked again: with the
      -- indicator now sitting in its own blank margin to the left of
      -- the move list (see section 3 below) rather than inside the
      -- TYPE/PP box, LEFT no longer needs the moveIndex==1 gating the
      -- UP version needed -- vanilla moveSelect doesn't read "left" at
      -- all in the classic (non-wide) layout, confirmed by reading the
      -- input code end to end, so intercepting it here can't collide
      -- with anything vanilla does with that key.
      elseif input:wasPressed("left") then
        self.megaFocused = true
        local realPhase = self.phase
        self.phase = "__kme_focus__"
        originalUpdate(self, dt)
        self.phase = realPhase
        return
      end
    end
    return originalUpdate(self, dt)
  end

  ------------------------------------------------------------------
  -- 3. Drawing, part one: the indicator, in the blank margin left of
  -- the move list (tile column 0-3, rows 13-17 -- pixel (0,104)-
  -- (32,144), confirmed outside both the TYPE/PP box and the move list
  -- box). Previously split across two lines, "ME"/"GA", to leave room
  -- for a separate cursor glyph -- that read as two broken fragments
  -- instead of a word. Now a single line, "MEGA" (32px, exactly filling
  -- the available width), with no separate cursor glyph at all -- focus
  -- is shown by inverting the colors (black-filled background, white
  -- text) instead, the same idea as a normal text cursor without
  -- needing the extra 8px column a glyph would have cost.
  ------------------------------------------------------------------
  local originalDrawTextArea = BattleState.drawTextArea
  function BattleState:drawTextArea()
    originalDrawTextArea(self)
    if megaEligible(self) then
      if self.megaFocused then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", 0, 112, 32, 8)
        love.graphics.setColor(1, 1, 1, 1)
      else
        love.graphics.setColor(0, 0, 0, 1)
      end
      Font.draw("MEGA", 0, 112)
    end
  end

  ------------------------------------------------------------------
  -- 4. Drawing, part two: the flash (unchanged) and the picker box,
  -- enlarged so nothing gets cut off.
  --
  -- Old box: tile (5,3) size (10,6) -> 64px interior width. "MEGA
  -- EVOLVE?" alone is 12 glyphs = 96px -- wider than the whole old box,
  -- which is exactly why it was overflowing. New box: tile (2,2) size
  -- (16,7) -> pixel (16,16)-(144,72), 112px interior width -- enough
  -- for "MEGA EVOLVE?" (96px) and "A:YES  B:NO" (88px) with real margin
  -- left over on both.
  ------------------------------------------------------------------
  local originalDraw = BattleState.draw
  function BattleState:draw()
    originalDraw(self)
    if self.megaFlashTimer and self.megaFlashTimer > 0 then
      local onBlack = math.floor(self.megaFlashTimer / 3) % 2 == 0
      love.graphics.setColor(onBlack and 0 or 1, onBlack and 0 or 1, onBlack and 0 or 1, 1)
      love.graphics.rectangle("fill", 0, 0, 160, 144)
    end
    if self.megaPickerOpen and self.player and self.player.mon then
      local entry = MEGA_FORMS[self.player.mon.species]
      if entry then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("fill", 16, 16, 128, 56)
        Font.drawBox(2, 2, 16, 7)
        love.graphics.setColor(0, 0, 0, 1)
        if entry.kind == "dual" then
          Font.draw(Strings("MEGA EVOLVE"), 24, 24)
          Font.draw("X", 40, 40)
          Font.draw("Y", 40, 48)
          Font.drawCode(self.megaPickerIndex == 1 and 0xED or 0xEC, 24, 40)
          Font.drawCode(self.megaPickerIndex == 2 and 0xED or 0xEC, 24, 48)
        else
          Font.draw(Strings("MEGA EVOLVE?"), 24, 32)
          Font.draw("A:YES  B:NO", 24, 48)
        end
      end
    end
  end

  ------------------------------------------------------------------
  -- 5. Summary/stats screen (opened via PKMN -> STATS mid-battle).
  -- SummaryMenu.lua reads mon.stats.* and a sprite loaded once in
  -- .new() -- neither is aware of battle.player.curStats/sprite, the
  -- separate, battle-only fields Mega Evolution actually sets (#see
  -- earlier conversation: confirmed via SummaryMenu.lua:151-152 and
  -- Damage.lua/TurnOrder.lua -- the boost is real in combat math, this
  -- screen just never reads the field it lives in). Same wrap
  -- technique as everything else in this mod, applied to a different
  -- module. Detection: search the screen stack for a BattleState
  -- instance whose player.mon IS the mon this summary screen is for,
  -- and whose megaFormId is set -- that's specific enough that a
  -- benched party member (not the active battler) never matches, even
  -- mid-battle.
  ------------------------------------------------------------------
  local SummaryMenu = require("src.ui.SummaryMenu")

  local function findActiveMegaBattle(game, mon)
    local states = game.stack and game.stack.states
    if not states then return nil end
    for i = #states, 1, -1 do
      local state = states[i]
      if state and state.player and state.player.mon == mon
        and state.player.megaFormId then
        return state
      end
    end
    return nil
  end

  local originalSummaryNew = SummaryMenu.new
  function SummaryMenu.new(game, mon)
    local self = originalSummaryNew(game, mon)
    local battle = findActiveMegaBattle(game, mon)
    if battle then
      local newDef = mod.content.pokemon:get(battle.player.megaFormId)
      if newDef then
        -- Real art species only -- data-only (non-Kanto) Mega records
        -- have no customArt, so this leaves the base species' own
        -- sprite showing rather than erroring or drawing nothing.
        for _, form in pairs(MEGA_FORMS) do
          local candidates = form.kind == "dual" and { form.x, form.y } or { form }
          for _, f in ipairs(candidates) do
            if f.id == battle.player.megaFormId and f.customArt and f.customArt.front then
              local ok, img = pcall(love.graphics.newImage, mod.assets:path(f.customArt.front))
              if ok then
                self.sprite = img
                self.spriteTrueColor = true
              end
            end
          end
        end
      end
    end
    return self
  end

  local originalSummaryDraw = SummaryMenu.draw
  function SummaryMenu:draw()
    local battle = findActiveMegaBattle(self.game, self.mon)
    if battle and self.page == 1 then
      local realStats = {
        attack = self.mon.stats.attack, defense = self.mon.stats.defense,
        speed = self.mon.stats.speed, special = self.mon.stats.special,
      }
      self.mon.stats.attack = battle.player.curStats.attack
      self.mon.stats.defense = battle.player.curStats.defense
      self.mon.stats.speed = battle.player.curStats.speed
      self.mon.stats.special = battle.player.curStats.special
      originalSummaryDraw(self)
      self.mon.stats.attack = realStats.attack
      self.mon.stats.defense = realStats.defense
      self.mon.stats.speed = realStats.speed
      self.mon.stats.special = realStats.special
    else
      originalSummaryDraw(self)
    end
  end

end
