-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

if KemGlobal == nil then
  _G.KemGlobal = class({}) -- put KemGlobal in the global scope
  
  --refer to: http://stackoverflow.com/questions/6586145/lua-require-with-global-local
end

--LinkLuaModifier("modifier_charges", "modifiers/modifier_charges", LUA_MODIFIER_MOTION_NONE)
require('internal/util')
require('gamemode')
--require('kem')
--SETTING_KIEMDOAN_SWORD_EFFECT ="particles/units/heroes/hero_kunkka/kunkka_weapon_tidebringer.vpcf"


function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See GameMode:PostLoadPrecache() in gamemode.lua for more information
  ]]

  DebugPrint("[BAREBONES] Performing pre-load precache")
  --PrecacheResource("particle", SETTING_KIEMDOAN_SWORD_EFFECT, context)
  PrecacheResource("particle", "particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf",context)
  PrecacheResource("soundfile","soundevents/game_sounds_heroes/game_sounds_tiny.vsndevts",context)
  PrecacheResource("soundfile","soundevents/game_sounds_heroes/game_sounds_kunkka.vsndevts",context)
  --item
  PrecacheResource("particle","particles/units/heroes/hero_warlock/warlock_shadow_word_buff.vpcf",context)
  PrecacheResource("particle","particles/invulernable.vpcf",context)
  --diep tinh
  PrecacheResource("soundfile","soundevents/game_sounds_heroes/game_sounds_lich.vsndevts",context)
  PrecacheResource("soundfile","soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts",context)
  PrecacheResource("soundfile","soundevents/voscripts/game_sounds_vo_crystalmaiden.vsndevts",context)
  
  --heaven boss
  PrecacheResource("soundfile","soundevents/game_sounds_heroes/game_sounds_templar_assassin.vsndevts",context)
  PrecacheResource("soundfile","soundevents/voscripts/game_sounds_vo_skywrath_mage.vsndevts",context)
  PrecacheResource("soundfile","soundevents/game_sounds_heroes/game_sounds_lich.vsndevts",context)
  
  --hell boss
  PrecacheResource("particle","particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf",context)
  PrecacheResource("soundfile","soundevents/game_sounds_heroes/game_sounds_lina.vsndevts",context)
  PrecacheResource("particle","particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf",context)
  
  -- Particles can be precached individually or by folder
  -- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
  --PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
  --PrecacheResource("particle_folder", "particles/test_particle", context)

  -- Models can also be precached by folder or individually
  -- PrecacheModel should generally used over PrecacheResource for individual models
  --PrecacheResource("model_folder", "particles/heroes/antimage", context)
  --PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
  --PrecacheModel("models/heroes/viper/viper.vmdl", context)

  -- Sounds can precached here like anything else
  --PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context)

  -- Entire items can be precached by name
  -- Abilities can also be precached in this way despite the name
  --PrecacheItemByNameSync("example_ability", context)
  --PrecacheItemByNameSync("item_example_item", context)

  -- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
  -- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
  --PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
  --PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
end

-- Create the game mode when we activate
function Activate()
  GameRules.DropTable = LoadKeyValues("scripts/kv/loots.kv")
  
  
  GameRules.GameMode = GameMode()
  GameRules.GameMode:InitGameMode()
  
end