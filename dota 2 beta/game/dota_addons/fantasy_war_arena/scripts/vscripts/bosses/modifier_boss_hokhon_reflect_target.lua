modifier_boss_hokhon_reflect_target = class({})
function modifier_boss_hokhon_reflect_target:IsHidden()
   return false
end
function modifier_boss_hokhon_reflect_target:RemoveOnDeath()
   return true
end

function modifier_boss_hokhon_reflect_target:GetEffectName()
  return ""
end
--function modifier_poison:GetEffectName()
--  return "particles/units/heroes/hero_venomancer/venomancer_poison_debuff_nova.vpcf"
--end
function modifier_boss_hokhon_reflect_target:GetTexture()
  return "item_blademail"
end

function modifier_boss_hokhon_reflect_target:IsDebuff()
  return false
end

function modifier_boss_hokhon_reflect_target:DeclareFunctions(  )
 local funcs = {
    MODIFIER_EVENT_ON_TAKEDAMAGE
  }
 
  return funcs
end
function modifier_boss_hokhon_reflect_target:OnTakeDamage( params )
if(IsServer())then
    if(self:GetParent()==params.unit)then
      local damage_taken = params.damage
      if(damage_taken>0)then
        --PrintTable(params)
        --print("Deal back damage")
        if(params.damage_flags~=DOTA_DAMAGE_FLAG_REFLECTION)then
          local damage = params.damage*0.2 
          DamageHandler:ApplyDamage(self:GetParent(),nil,params.attacker,damage,
            DamageHandler:InitCrit(0,0),ELEMENT_METAL,
            {flag="reflect"})
        end
        
      end
    end
  end
end
function modifier_boss_hokhon_reflect_target:OnCreated( kv )

end



function modifier_boss_hokhon_reflect_target:OnDestroy( kv )
 
end
