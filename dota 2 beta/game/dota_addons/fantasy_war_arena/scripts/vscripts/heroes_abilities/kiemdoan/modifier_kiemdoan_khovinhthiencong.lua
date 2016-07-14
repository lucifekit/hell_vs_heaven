modifier_kiemdoan_khovinhthiencong = class({})
--------------------------------------------------------------------------------
SETTING_HEALTH_PROC = 25
SETTING_COOLDOWN = 30
SETTING_BUFF_DURATION = 10
SETTING_BUFF_MODIFIER  = "modifier_kiemdoan_khovinhthiencong_active"
LinkLuaModifier(SETTING_BUFF_MODIFIER,"heroes_abilities/kiemdoan/"..SETTING_BUFF_MODIFIER, LUA_MODIFIER_MOTION_NONE )
function modifier_kiemdoan_khovinhthiencong:IsHidden()
  return true
end
function modifier_kiemdoan_khovinhthiencong:RemoveOnDeath()
  return false
end

function modifier_kiemdoan_khovinhthiencong:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_EVENT_ON_TAKEDAMAGE
  }
 
  return funcs
end
function modifier_kiemdoan_khovinhthiencong:GetModifierAttackSpeedBonus_Constant( params)
  --PrintTable(params)
  return self.atk_speed
end

--------------------------------------------------------------------------------
function modifier_kiemdoan_khovinhthiencong:OnTakeDamage(params)
  if(self:GetAbility():IsCooldownReady())then
    local caster = self:GetCaster()
    if(caster:GetHealthPercent()<SETTING_HEALTH_PROC)then
      self:GetAbility():StartCooldown(SETTING_COOLDOWN)
      caster:AddNewModifier( caster, self:GetAbility(),SETTING_BUFF_MODIFIER, { duration = SETTING_BUFF_DURATION } )
      
    end
   end
end
function modifier_kiemdoan_khovinhthiencong:OnCreated( kv )
 
  self.atk_speed = math.ceil(10+math.floor(self:GetAbility():GetLevel()*2))
  
end

--------------------------------------------------------------------------------
function modifier_kiemdoan_khovinhthiencong:OnRefresh( kv )
  self.atk_speed = math.ceil(10+math.floor(self:GetAbility():GetLevel()*2))
end