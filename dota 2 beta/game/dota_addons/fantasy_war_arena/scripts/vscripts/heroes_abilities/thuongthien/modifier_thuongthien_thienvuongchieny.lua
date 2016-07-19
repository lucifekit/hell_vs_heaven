modifier_thuongthien_thienvuongchieny = class({})
function modifier_thuongthien_thienvuongchieny:IsHidden()
   return false
end

function modifier_thuongthien_thienvuongchieny:IsAura()
   return true
end
function modifier_thuongthien_thienvuongchieny:GetAuraRadius()
   return 900
end
LinkLuaModifier("modifier_thuongthien_thienvuongchieny_allies","heroes_abilities/thuongthien/modifier_thuongthien_thienvuongchieny_allies", LUA_MODIFIER_MOTION_NONE )

function modifier_thuongthien_thienvuongchieny:GetModifierAura()
  return "modifier_thuongthien_thienvuongchieny_allies"
end
function modifier_thuongthien_thienvuongchieny:GetAuraEntityReject(h)
   if(h==self:GetParent())then
    return true
   end
   return false
end

--GetAuraEntityReject bool GetAuraEntityReject(handle hEntity)  Return true/false if this entity should receive the aura under specific conditions
--GetAuraRadius int GetAuraRadius() Return the range around the parent this aura tries to apply its buff.
--GetAuraSearchFlags  int GetAuraSearchFlags()  Return the unit flags this aura respects when placing buffs.
--GetAuraSearchTeam int GetAuraSearchTeam() Return the teams this aura applies its buff to.
--GetAuraSearchType int GetAuraSearchType() Return the unit classifications this aura applies its buff to.
--function modifier_thuongthien_thienvuongchieny:GetAuraSearchFlags()
--   return 900
--end
function modifier_thuongthien_thienvuongchieny:GetAuraSearchTeam()
   return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_thuongthien_thienvuongchieny:GetAuraSearchType()
   return DOTA_UNIT_TARGET_HERO
end
function modifier_thuongthien_thienvuongchieny:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end
function modifier_thuongthien_thienvuongchieny:RemoveOnDeath()
   return false
end

function modifier_thuongthien_thienvuongchieny:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_thuongthien_thienvuongchieny::GetModifierAttackSpeedBonus_Constant( params)
--Return self.atk_speed
--end

--function modifier_thuongthien_thienvuongchieny:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_thuongthien_thienvuongchieny:OnCreated( kv )
  if(IsServer())then
    kemPrint("create thien vuong chien y")
  end
  
end

function modifier_thuongthien_thienvuongchieny:OnRefresh( kv )
  if(IsServer())then
    kemPrint("refresh thien vuong chien y")
  end
end

function modifier_thuongthien_thienvuongchieny:OnDestroy( kv )
  if(IsServer())then
    kemPrint("destroy thien vuong chien y")
  end
end
