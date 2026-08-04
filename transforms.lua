-- mods/kanto_mega_evolutions/transforms.lua
--
-- Recolors 20 of the 21 Kanto Mega forms from their real vanilla battle
-- sprites, on the player's own machine, from their own imported ROM
-- cache. No ROM-derived bytes ship in this file. Charizard X is the one
-- exception -- it keeps the real custom art supplied earlier, so it's
-- not in this list.
--
-- As agreed: these are placeholder recolors, not the real Mega designs.
-- Most real Mega forms have genuine shape changes (extra limbs, wings,
-- armor plates) that a palette shift alone can't capture -- this is a
-- deliberate, disclosed placeholder until real art exists per species,
-- same tradeoff Charizard X had before its real art arrived.
--
-- Real source filenames confirmed against tools/rom_manifest.json's
-- pokemonAssets table for each species -- NOT a naive lowercase-name
-- guess (Charizard's own back picture taught us the back slug isn't
-- always front+nothing; here every back slug is front+"b", confirmed
-- for all 17 species below, but confirmed each one rather than assumed
-- the pattern would hold).

-- lightest -> darkest, one set per output form. Chosen per species'
-- real Mega color scheme where well-known (Gyarados red/black,
-- Pidgeot gold, Gengar shadow-purple), otherwise a reasonable type-
-- themed spread.
local SHADES = {
  starmie_mega      = { {200,230,255}, {100,170,230}, {200,170,40}, {15,20,35} },
  kangaskhan_mega   = { {230,190,160}, {180,100,60},  {120,50,30},  {30,10,10} },
  mewtwo_mega_x     = { {210,210,255}, {110,110,220}, {60,60,150},  {10,10,30} },
  mewtwo_mega_y     = { {240,220,255}, {180,140,230}, {110,70,170}, {25,15,40} },
}

-- { outPrefix, baseFrontSlug, baseBackSlug }. baseBackSlug follows the
-- confirmed front+"b" pattern for every one of these (verified per
-- species against tools/rom_manifest.json, not assumed).
local FORMS = {
  { "starmie_mega",    "starmie",    "starmieb" },
  { "kangaskhan_mega", "kangaskhan", "kangaskhanb" },
  { "mewtwo_mega_x",   "mewtwo",     "mewtwob" },
  { "mewtwo_mega_y",   "mewtwo",     "mewtwob" },
}

return function(ctx)
  for _, form in ipairs(FORMS) do
    local outPrefix, frontSlug, backSlug = form[1], form[2], form[3]
    local shades = SHADES[outPrefix]
    local front = ctx.readImage("battle/front/" .. frontSlug .. ".png")
    ctx.writeImage(ctx.recolor(front, shades),
                    "battle/front/" .. outPrefix .. ".png")
    local back = ctx.readImage("battle/back/" .. backSlug .. ".png")
    ctx.writeImage(ctx.recolor(back, shades),
                    "battle/back/" .. outPrefix .. ".png")
  end
end
