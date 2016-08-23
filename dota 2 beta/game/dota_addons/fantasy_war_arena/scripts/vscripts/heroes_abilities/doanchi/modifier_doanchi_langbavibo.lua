modifier_doanchi_langbavibo = class({})
require('kem_lib/kem')
--------------------------------------------------------------------------------

function modifier_doanchi_langbavibo:IsPurgable()
  return true
end
function modifier_doanchi_langbavibo:IsDebuff()
  return false
end

function modifier_doanchi_langbavibo:GetEffectName()
  return ""
end

function modifier_doanchi_langbavibo:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
  }
 
  return funcs
end
function modifier_doanchi_langbavibo:GetModifierMoveSpeedBonus_Constant( params,keke )
  
  
  return 200
end

--function modifier_kiemdoan_thiennambophap:CheckState()
--  local state = {
--  [MODIFIER_STATE_STUNNED] = true,
--  [MODIFIER_STATE_NO_UNIT_COLLISION] = true
--  }
-- 
--  return state
--end

--function modifier_kiemdoan_thiennambophap:GetOverrideAnimation( params )
--  return ACT_DOTA_FLAIL
--end

--------------------------------------------------------------------------------

function modifier_doanchi_langbavibo:OnCreated( kv )
  if IsServer() then
    --DeepPrintTable(kv)
    --self.vStartPos = self:GetParent():GetOrigin()
    --self.vEndPos = Vector( kv["target_x"], kv["target_y"], kv["target_y"] )

    --self:GetParent():StartGesture( ACT_DOTA_TELEPORT )
    --self:StartIntervalThink( self:GetAbility():GetChannelTime() - 0.25 )

    --EmitSoundOnLocationWithCaster( self.vStartPos, "Hero_Furion.Teleport_Grow", self:GetCaster() )
    --EmitSoundOnLocationWithCaster( self.vEndPos, "Hero_Furion.Teleport_Grow", self:GetCaster() )
  end
end

--------------------------------------------------------------------------------

function modifier_doanchi_langbavibo:OnDestroy()
  if IsServer() then
    --StopSoundOn( "Hero_Furion.Teleport_Grow", self:GetCaster() )
    --StopSoundOn( "Hero_Furion.Teleport_Grow", self:GetCaster() )

    --self:GetParent():RemoveGesture( ACT_DOTA_TELEPORT )
  end
end

--------------------------------------------------------------------------------

function modifier_doanchi_langbavibo:OnIntervalThink()
  if IsServer() then
    --StopSoundOn( "Hero_Furion.Teleport_Grow", self:GetCaster() )
    --StopSoundOn( "Hero_Furion.Teleport_Grow", self:GetCaster() )

    --self:StartIntervalThink( 1.5 )

    --EmitSoundOnLocationWithCaster( self.vStartPos, "Hero_Furion.Teleport_Disappear", self:GetCaster() )
    --EmitSoundOnLocationWithCaster( self.vEndPos, "Hero_Furion.Teleport_Appear", self:GetCaster() )
  end
end

--------------------------------------------------------------------------------
