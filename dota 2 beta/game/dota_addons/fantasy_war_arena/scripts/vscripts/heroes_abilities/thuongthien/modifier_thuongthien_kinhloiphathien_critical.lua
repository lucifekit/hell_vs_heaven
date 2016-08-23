modifier_thuongthien_kinhloiphathien_critical = class({})
require('kem_lib/kem')
function modifier_thuongthien_kinhloiphathien_critical:IsHidden()
   return false
end

function modifier_thuongthien_kinhloiphathien_critical:RemoveOnDeath()
   return false
end

function modifier_thuongthien_kinhloiphathien_critical:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_thuongthien_kinhloiphathien::GetModifierAttackSpeedBonus_Constant( params)
--Return self.atk_speed
--end

--function modifier_thuongthien_kinhloiphathien:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_thuongthien_kinhloiphathien_critical:OnCreated( kv )
 
  if(IsServer())then

    UpgradeSkillForHero(self:GetParent())
  end
  
  -- DANGER ZONE
--local invulnerable_duration = 0.83+0.334*skill_level
--local critical_chance = 40+40*skill_level
--local maim_chance = 40+8*skill_level
--local buff_duration = 15
--local cooldown = 30
  
end

function modifier_thuongthien_kinhloiphathien_critical:OnRefresh( kv )
end

function modifier_thuongthien_kinhloiphathien_critical:OnDestroy( kv )
  if(IsServer())then
    UpgradeSkillForHero(self:GetParent())
  end
end
