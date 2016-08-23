modifier_tutien_toidocthuat = class({})
require('kem_lib/kem')
function modifier_tutien_toidocthuat:IsHidden()
   return false
end
function modifier_tutien_toidocthuat:GetEffectName()
   return "particles/edited_particle/tu_tien/tdt.vpcf"
end

function modifier_tutien_toidocthuat:RemoveOnDeath()
   return false
end
--AURA DATA
function modifier_tutien_toidocthuat:IsAura()
   return true
end

function modifier_tutien_toidocthuat:GetAuraRadius()
   return 900
end
LinkLuaModifier("modifier_tutien_toidocthuat_allies","heroes_abilities/tutien/modifier_tutien_toidocthuat_allies", LUA_MODIFIER_MOTION_NONE )

function modifier_tutien_toidocthuat:GetModifierAura()
  return "modifier_tutien_toidocthuat_allies"
end
function modifier_tutien_toidocthuat:GetAuraEntityReject(h)
   if(h==self:GetParent())then
    return true
   end
   return false
end

function modifier_tutien_toidocthuat:GetAuraSearchTeam()
   return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_tutien_toidocthuat:GetAuraSearchType()
   return DOTA_UNIT_TARGET_HERO
end
function modifier_tutien_toidocthuat:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

--END AURA

function modifier_tutien_toidocthuat:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_tutien_toidocthuat:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_tutien_toidocthuat:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_tutien_toidocthuat:OnCreated( kv )
end

function modifier_tutien_toidocthuat:OnRefresh( kv )
end
