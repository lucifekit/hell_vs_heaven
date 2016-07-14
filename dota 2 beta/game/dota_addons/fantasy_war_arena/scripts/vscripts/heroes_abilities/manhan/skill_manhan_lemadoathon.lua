skill_manhan_lemadoathon = class({})
SETTING_DEBUFF_RADIUS = 120
SETTING_DEBUFF_DURATION = 120
SETTING_SKILL_MODIFIER = "modifier_manhan_lemadoathon"

LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/manhan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )

function skill_manhan_lemadoathon:OnUpgrade()
   local caster = self:GetCaster()
   caster:AddNewModifier(caster, self, SETTING_SKILL_MODIFIER,{})
   caster:CalculateStatBonus()
   UpgradeSkill(caster:GetPlayerID())
end
--function skill_manhan_lemadoathon:OnAbilityPhaseStart()
--  self:GetCaster():StartGesture( ACT_DOTA_ATTACK)
--  return true
--end
--
--function skill_manhan_lemadoathon:OnSpellStart()
--  local caster = self:GetCaster()
--  local cast_point = self:GetCursorPosition()
--
--  local enemies = FindUnitsInRadius(caster:GetTeam(), cast_point, nil, SETTING_DEBUFF_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
--  if #enemies > 0 then
--    for _,enemy in pairs(enemies) do
--      enemy:AddNewModifier( self:GetCaster(), self,SETTING_SKILL_MODIFIER, { duration = SETTING_DEBUFF_DURATION } )
--    end
--  end
--end