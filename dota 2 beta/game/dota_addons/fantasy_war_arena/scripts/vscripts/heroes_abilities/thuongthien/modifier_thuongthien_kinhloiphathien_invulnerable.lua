modifier_thuongthien_kinhloiphathien_invulnerable = class({})
function modifier_thuongthien_kinhloiphathien_invulnerable:IsHidden()
   return false
end

function modifier_thuongthien_kinhloiphathien_invulnerable:RemoveOnDeath()
   return false
end

function modifier_thuongthien_kinhloiphathien_invulnerable:DeclareFunctions()
local funcs = {
   MODIFIER_PROPERTY_AVOID_DAMAGE
}
return funcs
end

function modifier_thuongthien_kinhloiphathien_invulnerable:GetModifierAvoidDamage( params)
  return 1
end

--function modifier_thuongthien_kinhloiphathien:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end

function modifier_thuongthien_kinhloiphathien_invulnerable:OnCreated( kv )
  
  -- DANGER ZONE
--local invulnerable_duration = 0.83+0.334*skill_level
--local critical_chance = 40+40*skill_level
--local maim_chance = 40+8*skill_level
--local buff_duration = 15
--local cooldown = 30
  
end

function modifier_thuongthien_kinhloiphathien_invulnerable:OnRefresh( kv )
end
