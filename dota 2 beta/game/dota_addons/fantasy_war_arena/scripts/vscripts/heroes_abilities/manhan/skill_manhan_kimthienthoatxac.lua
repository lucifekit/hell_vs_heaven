skill_manhan_kimthienthoatxac = class({})
SETTING_SKILL_MODIFIER = "modifier_manhan_kimthienthoatxac"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/manhan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function skill_manhan_kimthienthoatxac:GetPhysicEvade()
  return self:GetLevel()*2 --250
end

function skill_manhan_kimthienthoatxac:GetMaimResistTime()
  return self:GetLevel()*17 --50
end
function skill_manhan_kimthienthoatxac:OnUpgrade()
   local caster = self:GetCaster()
   caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{})
   caster:CalculateStatBonus()
   UpgradeSkill(caster:GetPlayerID())
end