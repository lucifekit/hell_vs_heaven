modifier_kiemcon_loidinhquyet = class({})
require('kem_lib/kem')
function modifier_kiemcon_loidinhquyet:IsHidden()
   return false
end

function modifier_kiemcon_loidinhquyet:RemoveOnDeath()
   return false
end
function modifier_kiemcon_loidinhquyet:IsAura()
   return true
end
function modifier_kiemcon_loidinhquyet:GetAuraRadius()
   return 900
end
LinkLuaModifier("modifier_kiemcon_loidinhquyet_target","heroes_abilities/kiemcon/modifier_kiemcon_loidinhquyet_target", LUA_MODIFIER_MOTION_NONE )

function modifier_kiemcon_loidinhquyet:GetModifierAura()
  return "modifier_kiemcon_loidinhquyet_target"
end
function modifier_kiemcon_loidinhquyet:GetAuraEntityReject(h)
   if(h==self:GetParent())then
    return true
   end
   return false
end

function modifier_kiemcon_loidinhquyet:GetAuraSearchTeam()
   return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_kiemcon_loidinhquyet:GetAuraSearchType()
   return DOTA_UNIT_TARGET_HERO
end
function modifier_kiemcon_loidinhquyet:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_kiemcon_loidinhquyet:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_kiemcon_loidinhquyet:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_kiemcon_loidinhquyet:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_kiemcon_loidinhquyet:OnCreated( kv )
end

function modifier_kiemcon_loidinhquyet:OnRefresh( kv )
end
