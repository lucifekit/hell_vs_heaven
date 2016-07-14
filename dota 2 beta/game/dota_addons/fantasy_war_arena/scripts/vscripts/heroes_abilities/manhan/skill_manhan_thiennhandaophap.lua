skill_manhan_thiennhandaophap = class({})
SETTING_SKILL_MODIFIER = "modifier_manhan_thiennhandaophap"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/manhan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

function skill_manhan_thiennhandaophap:GetElementDamage()
  return self:GetLevel()*50 --250
end

function skill_manhan_thiennhandaophap:GetCriticalChance()
  return self:GetLevel()*10 --50
end
function skill_manhan_thiennhandaophap:OnUpgrade()
   local caster = self:GetCaster()
   caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{})
   caster:CalculateStatBonus()
   UpgradeSkill(caster:GetPlayerID())
   -- BASIC TALENT
--local attack_speed = 5+2*skill_level
--local element_damage = 0+50*skill_level
--local critical_chance = 0+10*skill_level
   
end