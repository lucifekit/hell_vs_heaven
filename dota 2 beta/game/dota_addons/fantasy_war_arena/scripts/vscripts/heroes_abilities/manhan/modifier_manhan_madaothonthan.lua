modifier_manhan_madaothonthan = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
require('heroes_abilities/manhan/manhan')

function modifier_manhan_madaothonthan:IsHidden()
  return false
end
function modifier_manhan_madaothonthan:RemoveOnDeath()
  return true
end
function modifier_manhan_madaothonthan:CastMDTT()

end
function modifier_manhan_madaothonthan:OnIntervalThink()
  if(IsServer())then
    local caster = self:GetParent()
    CastMDTT(caster,self:GetAbility())
  
  end
  
   
end
function modifier_manhan_madaothonthan:OnCreated( kv )

  --kemPrint("Created ma dao thon than"..self:GetParent():GetUnitName())
  if(IsServer())then
    local p = self:GetParent()
    local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)  
    self.move_speed = 20+skill_level*8
    self.paralyze_chance = 3+skill_level
    self.paralyze_duration = 2+0.2*skill_level
    self.speed_duration = 5+2*skill_level
    self:StartIntervalThink( 5 )
  end
  
  --kemPrint("Created thucphocchu")

end

--------------------------------------------------------------------------------
function modifier_manhan_madaothonthan:OnRefresh( kv )
  local p = self:GetParent()
  local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)  
  self.move_speed = 20+skill_level*8
  self.paralyze_chance = 3+skill_level
  self.paralyze_duration = 2+0.2*skill_level
  self.speed_duration = 5+2*skill_level

  --kemPrint("Refreshed thucphocchu")
end
function modifier_manhan_madaothonthan:OnDestroy()
  if(IsServer())then
    self:StartIntervalThink(-1)
  end

end