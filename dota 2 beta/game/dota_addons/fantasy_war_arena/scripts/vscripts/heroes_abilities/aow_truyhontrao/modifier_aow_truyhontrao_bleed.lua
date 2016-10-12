modifier_aow_truyhontrao_bleed = class({})
require('kem_lib/kem')
function modifier_aow_truyhontrao_bleed:IsHidden()
   return false
end

function modifier_aow_truyhontrao_bleed:RemoveOnDeath()
   return true
end

function modifier_aow_truyhontrao_bleed:GetEffectName()
   return "particles/units/heroes/hero_pudge/pudge_dismember.vpcf"
end
function modifier_aow_truyhontrao_bleed:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
  }
 
  return funcs
end
function modifier_aow_truyhontrao_bleed:GetModifierMoveSpeedBonus_Constant( params)
  --PrintTable(params)
  return math.max(-200,-5*self:GetStackCount())
end

function modifier_aow_truyhontrao_bleed:ActiveOnTakeHit(attacker)
    if(IsServer())then
      
       if(attacker.stat_tp)then
          local p = self:GetCaster()
          local skill_level = self:GetAbility():GetLevel()+GetSkillLevel(p)
          local dexterity_multiple = 0.03*skill_level
          local total_dex_multiple = self:GetStackCount()*dexterity_multiple
          local damage = attacker.stat_tp*total_dex_multiple
          if(self:GetParent():IsHero())then
            damage=damage*5
          end
          
          DamageHandler:ApplyDamage(
            attacker,
            self:GetAbility(),
            self:GetParent(),
            damage,
            DamageHandler:InitCrit(0,0),
            ELEMENT_METAL,
            {flag="no_director"})
       end
    end
end
