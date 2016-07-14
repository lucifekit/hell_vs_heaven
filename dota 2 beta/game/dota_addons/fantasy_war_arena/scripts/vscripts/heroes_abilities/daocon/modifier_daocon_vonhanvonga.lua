modifier_daocon_vonhanvonga = class({})
function modifier_daocon_vonhanvonga:IsHidden()
   return false
end

function modifier_daocon_vonhanvonga:RemoveOnDeath()
   return false
end
function modifier_daocon_vonhanvonga:IsAura()
   return true
end
function modifier_daocon_vonhanvonga:GetAuraRadius()
   return 900
end
LinkLuaModifier("modifier_daocon_vonhanvonga_allies","heroes_abilities/daocon/modifier_daocon_vonhanvonga_allies", LUA_MODIFIER_MOTION_NONE )

function modifier_daocon_vonhanvonga:GetModifierAura()
  return "modifier_daocon_vonhanvonga_allies"
end
function modifier_daocon_vonhanvonga:GetAuraEntityReject(h)
   if(h==self:GetParent())then
    return true
   end
   return false
end

function modifier_daocon_vonhanvonga:GetAuraSearchTeam()
   return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_daocon_vonhanvonga:GetAuraSearchType()
   return DOTA_UNIT_TARGET_HERO
end
function modifier_daocon_vonhanvonga:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end


function modifier_daocon_vonhanvonga:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_daocon_vonhanvonga:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_daocon_vonhanvonga:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_daocon_vonhanvonga:OnCreated( kv )
end

function modifier_daocon_vonhanvonga:OnRefresh( kv )
end
