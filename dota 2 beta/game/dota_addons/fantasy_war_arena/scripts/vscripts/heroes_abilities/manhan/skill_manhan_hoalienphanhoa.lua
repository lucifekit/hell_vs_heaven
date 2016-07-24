skill_manhan_hoalienphanhoa = class({})
LinkLuaModifier("modifier_manhan_hoalienphanhoa","heroes_abilities/manhan/modifier_manhan_hoalienphanhoa", LUA_MODIFIER_MOTION_NONE )
SETTING_HLPH_EFFECT = "particles/edited_particle/ma_nhan/hoalienphanhoa.vpcf"
SETTING_HLPH_START_EFFECT = "particles/edited_particle/ma_nhan/fx_hoalienphanhoa_start.vpcf"
SETTING_HLPH_SOUND_EFFECT = "Hero_MaNhan.HoaLienPhanHoa_Start"
SETTING_HLPH_END_SOUND_EFFECT = "Hero_MaNhan.HoaLienPhanHoa_End"

SETTING_TIME_BETWEEN_PULL = 2

SETTING_HLPH_MODIFIER = "modifier_manhan_hoalienphanhoa"
--SETTING_DCLD_EFFECT = ""particles/units/heroes/hero_phoenix/phoenix_icarus_dive_burn_debuff.vpcf"
--------------------------------------------------------------------------------
--
--
function skill_manhan_hoalienphanhoa:GetCooldown(  )
  return 70-8*self:GetLevel()
end
function skill_manhan_hoalienphanhoa:GetManaCost()
  return self:GetLevel()*20
end
function skill_manhan_hoalienphanhoa:OnAbilityPhaseStart()
  self:GetCaster():StartGesture( ACT_DOTA_RAZE_2)
  return true
end
function skill_manhan_hoalienphanhoa:OnSpellStart()



local caster = self:GetCaster()

--caster:AddNewModifier(caster, self, SETTING_HLPH_MODIFIER,{duration = 200})
--SetAnimation('raze3') --[[Returns:void
--Pass ''string'' for the animation to play on this model
--]]
local skill_level = self:GetLevel()
-- FLAME VORTEX
local pull_duration = 6
local pull_chance = 0.3+0.1*skill_level

local pull_radius = 500

local burn_chance = 0.08+0.02*skill_level
local burn_time = 2.5

local caster_position = caster:GetAbsOrigin()

local target_point = self:GetCursorPosition()
--self:PayManaCost()

  

  --CreateDummyUnit to cast sound
  local hlph_dummy_unit = CreateUnitByName("npc_dummy_unit", target_point, false, nil, nil, caster:GetTeam())
  hlph_dummy_unit:FindAbilityByName("dummy_unit"):SetLevel(1)
  hlph_dummy_unit:EmitSoundParams(SETTING_HLPH_SOUND_EFFECT, 1, 0.1, 1)
  
  
  local duration = SETTING_HLPH_DURATION
  
  --if mtcc then duration = 10
  
  local pfx = ParticleManager:CreateParticle(SETTING_HLPH_EFFECT,PATTACH_WORLDORIGIN,caster)

  ParticleManager:SetParticleControl( pfx, 0, target_point+Vector(0,0,50))
  
  local pfx2 = ParticleManager:CreateParticle(SETTING_HLPH_START_EFFECT,PATTACH_WORLDORIGIN,caster)
  ParticleManager:SetParticleControl( pfx2, 0, target_point+Vector(0,0,50))

  
  
  Timers:CreateTimer({
              endTime = pull_duration,
              callback = function()

                 --kemPrint("Destroy particle")
                 ParticleManager:DestroyParticle(pfx,true)
                 ParticleManager:DestroyParticle(pfx2,true)
                 --kemPrint("Stop sound")
                 hlph_dummy_unit:StopSound(SETTING_HLPH_SOUND_EFFECT)
                 --hlph_dummy_unit:EmitSoundParams(SETTING_HLPH_SOUND_END_EFFECT,1,1,1)
                 --kemPrint("Remove self")
                 hlph_dummy_unit:RemoveSelf()
                 --kemPrint("Removed")
              end
            })

--if mtcc then pull_radius =+200


  local pull_data = {
    caster = caster,
    ability = self,
    pull_chance = pull_chance*100,
    pull_point = target_point,
    pull_max_range = 300,
    pull_radius = pull_radius,
    pull_duration = pull_duration,
    pull_step = SETTING_TIME_BETWEEN_PULL,
    pull_custom = {
      action="status_effect",
      effect_type=EFFECT_BURN,
      effect_chance=burn_chance*100,
      effect_time=burn_time
    }
  }
  --kemPrint("Vacumming by "..caster:GetUnitName())
  StatusEffectHandler:Pull(pull_data)

          
          



  
  
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
