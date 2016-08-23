modifier_kiemcon_daocottienphong = class({})
require('kem_lib/kem')
function modifier_kiemcon_daocottienphong:IsHidden()
   return false
end

function modifier_kiemcon_daocottienphong:RemoveOnDeath()
   return true
end
function modifier_kiemcon_daocottienphong:GetEffectAttachType()
  return PATTACH_OVERHEAD_FOLLOW
end
function modifier_kiemcon_daocottienphong:GetEffectName()
  return "particles/edited_particle/kiem_con/dctp.vpcf"
end
function modifier_kiemcon_daocottienphong:DeclareFunctions()
local funcs = {
   --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
return funcs
end

--function modifier_kiemcon_daocottienphong:GetModifierAttackSpeedBonus_Constant( params)
--return self.atk_speed
--end

--function modifier_kiemcon_daocottienphong:CheckState()
   --local state = {
   --[MODIFIER_STATE_STUNNED] = true,
   --[MODIFIER_STATE_NO_UNIT_COLLISION] = true
--})
--return state
--end
function modifier_kiemcon_daocottienphong:Apply()
  if(IsServer())then
    local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
    local lightning_resist = 10+34*skill_level
    local physical_resist = 10+34*skill_level
    local fire_resist = 10+34*skill_level
    local water_resist = 10+34*skill_level
    
    local hero = self:GetParent()
    if(hero.inited)then
        hero.dctp_physical_resist = physical_resist
        hero.dctp_lightning_resist = lightning_resist
        hero.dctp_water_resist = water_resist
        hero.dctp_fire_resist = fire_resist
        hero.resist_metal = hero.resist_metal+hero.dctp_physical_resist
        hero.resist_earth = hero.resist_earth+hero.dctp_lightning_resist
        hero.resist_fire = hero.resist_fire+hero.dctp_fire_resist
        hero.resist_water = hero.resist_water+hero.dctp_water_resist
        UpdatePlayerDataForHero(hero)
    end
  end
end
function modifier_kiemcon_daocottienphong:GainBack()
  if(IsServer())then
    local hero = self:GetParent()
    if(hero.inited)then
        --fall back
          hero.resist_metal = hero.resist_metal-hero.dctp_physical_resist
          hero.resist_earth = hero.resist_earth-hero.dctp_lightning_resist
          hero.resist_fire = hero.resist_fire-hero.dctp_fire_resist
          hero.resist_water = hero.resist_water-hero.dctp_water_resist
          hero.dctp_physical_resist = 0
          hero.dctp_lightning_resist = 0
          hero.dctp_water_resist = 0
          hero.dctp_fire_resist = 0
          UpdatePlayerDataForHero(hero)
      end
  end
  
end
function modifier_kiemcon_daocottienphong:OnCreated( kv )
  if(IsServer())then
    self:Apply()
  end
  
end
function modifier_kiemcon_daocottienphong:OnRefresh()
  if(IsServer())then
    self:GainBack()
    self:Apply()
  end
end
function modifier_kiemcon_daocottienphong:OnDestroy()
  if(IsServer())then
    self:GainBack()
  end
end
