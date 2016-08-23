modifier_daocon_nhatkhitamthanh = class({})
require('kem_lib/kem')
function modifier_daocon_nhatkhitamthanh:IsHidden()
   return false
end

function modifier_daocon_nhatkhitamthanh:RemoveOnDeath()
   return false
end
function modifier_daocon_nhatkhitamthanh:IsAura()
   return true
end
function modifier_daocon_nhatkhitamthanh:GetAuraRadius()
   return 900
end
LinkLuaModifier("modifier_daocon_nhatkhitamthanh_allies","heroes_abilities/daocon/modifier_daocon_nhatkhitamthanh_allies", LUA_MODIFIER_MOTION_NONE )

function modifier_daocon_nhatkhitamthanh:GetModifierAura()
  return "modifier_daocon_nhatkhitamthanh_allies"
end
function modifier_daocon_nhatkhitamthanh:GetAuraEntityReject(h)
   if(h==self:GetParent())then
    return true
   end
   return false
end

function modifier_daocon_nhatkhitamthanh:GetAuraSearchTeam()
   return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_daocon_nhatkhitamthanh:GetAuraSearchType()
   return DOTA_UNIT_TARGET_HERO
end
function modifier_daocon_nhatkhitamthanh:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end



function modifier_daocon_nhatkhitamthanh:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_daocon_nhatkhitamthanh:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_daocon_nhatkhitamthanh:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_daocon_nhatkhitamthanh:OnCreated( kv )
end

function modifier_daocon_nhatkhitamthanh:OnRefresh( kv )
end
