modifier_manhan_lemadoathon = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------
--function modifier_manhan_lemadoathon:GetEffectAttachType()
--  return PATTACH_OVERHEAD_FOLLOW
--end
--function modifier_manhan_lemadoathon:GetEffectName()
--  return "particles/edited_particle/ma_nhan/fx_lemadoathon.vpcf"
--end
function modifier_manhan_lemadoathon:RemoveOnDeath()
  return false
end
function modifier_manhan_lemadoathon:IsHidden()
  return false
end
function modifier_manhan_lemadoathon:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_ABILITY_EXECUTED
  }
 
  return funcs
end

SETTING_COOLDOWN = 5
SETTING_DEBUFF_RADIUS = 900
SETTING_DEBUFF_DURATION = 120
SETTING_SKILL_MODIFIER = "modifier_manhan_lemadoathon_enemies"
LinkLuaModifier(SETTING_SKILL_MODIFIER,"heroes_abilities/manhan/"..SETTING_SKILL_MODIFIER, LUA_MODIFIER_MOTION_NONE )


function modifier_manhan_lemadoathon:OnAbilityExecuted(params)
if(IsServer())then
    --PrintTable(params)
    local cast_ability = params.ability
    local caster = params.unit
    local abilityname = cast_ability:GetAbilityName()
    if(string.sub(abilityname,0,5)~='item_')then
      if(abilityname~="skill_khinhcong")then
        if(caster==self:GetParent())then
          if(self:GetAbility():IsCooldownReady())then

                self:GetAbility():StartCooldown(SETTING_COOLDOWN)
                local caster = self:GetParent()
                local max_target = self.max_target
                local cast_point = caster:GetOrigin()
                local enemies = FindUnitsInRadius(caster:GetTeam(), cast_point, nil, SETTING_DEBUFF_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
                if #enemies > 0 then
                  for _,enemy in pairs(enemies) do
                    if(max_target>0)then
                      max_target = max_target-1
                      enemy:AddNewModifier( caster, self:GetAbility(),SETTING_SKILL_MODIFIER, { duration = SETTING_DEBUFF_DURATION } )
                    end
                  end
                end
          end
        end
      end
    end
    
  
end
  
end
--------------------------------------------------------------------------------

function modifier_manhan_lemadoathon:OnCreated( kv )
 if(IsServer())then
  local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  -- SOUL STEALER
--  local physical_simplify = 0.5+0.15*skill_level
--  local movement_speed_reduce = 20+8*skill_level
  self.max_target = math.floor(2.5+0.5*skill_level)
--local cooldown = 5
 end
  

end

--------------------------------------------------------------------------------
function modifier_manhan_lemadoathon:OnRefresh( kv )
if(IsServer())then
  local p = self:GetParent()
		local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
  -- SOUL STEALER
--  local physical_simplify = 0.5+0.15*skill_level
--  local movement_speed_reduce = 20+8*skill_level
  self.max_target = math.floor(2.5+0.5*skill_level)
--local cooldown = 5
 end
end

function modifier_manhan_lemadoathon:OnDestroy( kv )
end