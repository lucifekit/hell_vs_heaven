skill_kiemminh_lyhoadaiphap = class({})
SETTING_SKILL_MODIFIER = "modifier_kiemminh_lyhoadaiphap"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/kiemminh/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )


function skill_kiemminh_lyhoadaiphap:GetWeakInflictChance()
  return 20+self:GetLevel()*8
end

function skill_kiemminh_lyhoadaiphap:GetStunResistChance()
  return 30+self:GetLevel()*12
end

function skill_kiemminh_lyhoadaiphap:OnUpgrade()
   local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{})
  caster:CalculateStatBonus()
  UpgradeSkill(caster:GetPlayerID())

  -- EXPERT TALENT
--local weak_chance_increase = 20+8*skill_level
--local stun_chance_reduce = 30+12*skill_level
--local attack_speed = math.floor(10+1.6*skill_level)

end