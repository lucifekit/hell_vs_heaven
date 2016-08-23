skill_manhan_donchilietdiem = class({})
require('kem_lib/kem')
SETTING_DCLD_NUMBER_OF_FIRES = 1
SETTING_DCLD_DURATION_OF_FIRES = 2
SETTING_DCLD_SKILL_CODE = "skill_manhan_donchilietdiem"


SETTING_DCLD_EFFECT = "particles/edited_particle/ma_nhan/donchilietdiem.vpcf"
--SETTING_DCLD_EFFECT = "particles/units/heroes/hero_phoenix/phoenix_icarus_dive_char_glow.vpcf"
--------------------------------------------------------------------------------

SETTING_EFFECT_2 = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls_line.vpcf"
function skill_manhan_donchilietdiem:GetCooldown()
  --if mttc then return 0.5
  if(HasBook(self:GetCaster()))then
    return 0.5
  end
  return 2
end

function skill_manhan_donchilietdiem:GetManaCost()
  --if mttc then return 2
  local caster = self:GetCaster()
  local skill_level = self:GetLevel()+GetSkillLevel(caster)
  return skill_level*5
end

function skill_manhan_donchilietdiem:OnAbilityPhaseStart()
	--self:GetCaster():StartGesture( ACT_DOTA_RAZE_1)
	local atk_perseconds = self:GetCaster():GetAttacksPerSecond()
  self:GetCaster():StartGestureWithPlaybackRate( ACT_DOTA_RAZE_1,atk_perseconds)
	return true
end
function skill_manhan_donchilietdiem:OnSpellStart()

  local caster = self:GetCaster()
  local skill_level = self:GetLevel() + GetSkillLevel(caster)
  local caster_position = caster:GetAbsOrigin()
  local target_point = self:GetCursorPosition()
	--self:PayManaCost()


	
	    local particleName = SETTING_DCLD_EFFECT
	    --particleName = "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf"
	    
	    --particleName = "particles/frostivus_herofx/queen_shadow_strike_linear_parent.vpcf"

	    FxPoint(particleName,target_point,2)
	    SoundPoint("Hero_Huskar.Burning_Spear",target_point,2,caster:GetTeam())
	 
                
      -- HELL FIRE
local basic_damage = 1
local element_damage_min = 47+14*skill_level
local element_damage_max = 56+18*skill_level
local chance_to_burn = 0.15+0.025*skill_level
local burn_time = 2+0.1*skill_level
local max_target = math.floor(2+0.2*skill_level)
      
      local damageData = {
        caster = caster,
        main_magic = caster:GetIntellect(),
        skill_physical_damage_percent = 0,
        skill_tree_amplify_damage = 0,-- can edit
        skill_basic_damage_percent = basic_damage,
        element_damage_min = element_damage_min,
        element_damage_max = element_damage_max
        }
      local damageGroupData = {
        whoDealDamage = caster,
        byWhichAbility = self,

        where = target_point,
        radius = 150,
        period = 0.5,
        duration = 2,
        maxTarget = max_target,
        damage = DamageHandler:GetDamage(damageData),
        damage_element = ELEMENT_FIRE,
        custom = {
          action="status_effect",
          effect_type=EFFECT_BURN,
          effect_chance=chance_to_burn*100,
          effect_time=burn_time
        }
      }


      DamageHandler:DamageGroup(damageGroupData)
	
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------