modifier_game_speed = class({})
--------------------------------------------------------------------------------
function modifier_game_speed:RemoveOnDeath()
  return false
end
function modifier_game_speed:IsPurgable()
  return false
end
function modifier_game_speed:IsHidden()
  return true
end
function modifier_game_speed:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    MODIFIER_PROPERTY_MOVESPEED_MAX,
    --MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE
    --MODIFIER_PROPERTY_AVOID_DAMAGE--ko nhan damage
  }
 
  return funcs
end
function modifier_game_speed:GetModifierMoveSpeed_Limit( params)
  --PrintTable(params)
  return 800
end
function modifier_game_speed:GetModifierMoveSpeed_Max( params)
  --PrintTable(params)
  return 800
end

--function modifier_game_speed:GetModifierIncomingDamage_Percentage( params)
--  return 100
--end
function modifier_game_speed:GetModifierIncomingPhysicalDamage_Percentage( params)
  --return -100
  return -self.resist_physical
end
--function modifier_game_speed:GetModifierAvoidDamage( params)
-- 
--  return 0
--end
function modifier_game_speed:OnCreated(kv)
  self.resist_physical = 0
  if(IsServer())then
    local hero = self:GetParent()
    if(hero.resist_metal)then
      self.resist_physical = hero.resist_metal*100/(hero.resist_metal+1024)

    end
    
  end
  

end
function modifier_game_speed:OnRefresh(kv)
  self.resist_physical = 0
  if(IsServer())then
    local hero = self:GetParent()
    if(hero.resist_metal)then
      self.resist_physical = hero.resist_metal*100/(hero.resist_metal+1024)

      --kemPrint("Server Resist metal : "..hero.resist_metal.." ==> Block "..self.resist_physical.."% ")
    end
  end
  --kemPrint("Refresh game mechanic modifier")

end
