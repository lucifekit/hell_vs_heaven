skill_khinhcong = class({})
--require('kem')

require('kem_lib/player_data')

SETTING_MODIFIER_KHINHCONG_JUMPING = "modifier_khinhcong_jumping_lua"
SETTING_MODIFIER_KHINHCONG = "modifier_khinhcong_lua"
LinkLuaModifier( SETTING_MODIFIER_KHINHCONG,"modifiers/"..SETTING_MODIFIER_KHINHCONG, LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( SETTING_MODIFIER_KHINHCONG_JUMPING,"modifiers/"..SETTING_MODIFIER_KHINHCONG_JUMPING, LUA_MODIFIER_MOTION_NONE )
SETTING_JUMP_DISTANCE_MIN = 200 -- khoang cach nho nhat co the khinh cong
SETTING_JUMP_DURATION = 0.75
SETTING_JUMP_HEIGHT = 200
SETTING_JUMP_HEIGHT_FAR = 400
SETTING_JUMP_DURATION_FAR = 1.5
SETTING_JUMP_MAX_LENGTH = 1200
SETTING_START_GESTURE = ACT_DOTA_RUN
SETTING_JUMP_START_SOUND_EFFECT = "Hero_Tiny.Toss.Target"
SETTING_JUMP_END_SOUND_EFFECT = "Ability.TossThrow"
--------------------------------------------------------------------------------
function skill_khinhcong:OnAbilityPhaseStart()
	self:GetCaster():StartGesture( ACT_DOTA_RUN)
	return true
end




function skill_khinhcong:OnSpellStart()
	--DebugPrintTable(event)
  local caster   = self:GetCaster()
  local owner = caster:GetOwner()
  --owner.jump_time = owner.jump_time+1

  --kemPrint("So lan jump : "..owner.jump_time)
  
  local playerID = caster:GetPlayerID()
  

  if caster:HasModifier( SETTING_MODIFIER_KHINHCONG_JUMPING ) then
    --kemPrint("quit")

    --Say(nil, "Dang Nhay Ma", false)
    --local message = "Jumping"
    --UTIL_MessageText(caster:GetPlayerID()+1,message, 255, 25, 25, 255)
    
    return nil
  end
  --pl_data["jump_time"] = pl_data["jump_time"]+1
  --UTIL_MessageText(playerID+1,"Jump time : "..pl_data['jump_time'], 255, 25, 25, 255)
 
  

  local casterOrigin  = caster:GetAbsOrigin()
  --local casterAngles  = caster:GetAngles()


  local startTime = GameRules:GetGameTime()

  --kemPrint("Init target point " ..event.target_points)
  local point = self:GetCursorPosition()
  local target_point = self:GetCursorPosition()
  local caster_position =  caster:GetAbsOrigin()
  --kemPrint("Init target point "..point..event.target_points[1])

  --local angle_from_caster_to_target = math.atan2(vTargetPosition.y-caster_position.y, vTargetPosition.x-caster_position.x ) +math.rad(90)
  local canMove = true
  if(target_point.z-caster_position.z>200)then
        --cao qua
        canMove=false
   end
  local canFind = GridNav:CanFindPath(casterOrigin, target_point)
  local isBlock = GridNav:IsBlocked(target_point)
  local isTraversable = GridNav:IsTraversable(target_point)

  if(not canFind)then
    canMove =false
  end
  if(not isTraversable)then
    canMove=false
  end
  if(not canMove) then
    self:GetCaster():RemoveGesture(ACT_DOTA_RUN)
        local modifier = self:GetCaster():FindModifierByName(SETTING_MODIFIER_KHINHCONG)
        modifier:IncrementStackCount()
        return
  end
  local angle_from_caster_to_target = math.atan2(point.y-casterOrigin.y, point.x-casterOrigin.x ) 

  local point_difference_normalized = (point - casterOrigin)
  local distance = math.min(SETTING_JUMP_MAX_LENGTH+math.max(500,(caster.jump_time*10)),(point - casterOrigin):Length2D())
  
  if distance<SETTING_JUMP_DISTANCE_MIN then
    
    return nil  
  end
  IncreaseJumpTime(playerID)

  --kemPrint("add new modifier")
 -- kemPrint(modifierKhinhCong)
  caster:AddNewModifier(caster, self, SETTING_MODIFIER_KHINHCONG_JUMPING,nil)
  caster:EmitSound(SETTING_JUMP_START_SOUND_EFFECT)
  --kemPrint("ok")

  --local ability   = event.ability
  caster:StartGesture( SETTING_START_GESTURE)
  caster.disjointed = false
  
  local jump_height = SETTING_JUMP_HEIGHT
  local jump_duration = SETTING_JUMP_DURATION
  if distance>SETTING_JUMP_MAX_LENGTH/2 then
    --nhay xa
    jump_height = SETTING_JUMP_HEIGHT_FAR
    jump_duration= SETTING_JUMP_DURATION_FAR
  end
  self:StartCooldown(jump_duration)

  --caster:SetAngles(point_difference_normalized.x,point_difference_normalized.y,0)
  
  --caster:SetOrigin(point)
  caster:SetContextThink( DoUniqueString("updateKhinhCong"), function ( )
    self:CheckToInterrupt()
    local elapsedTime = GameRules:GetGameTime() - startTime
    if(elapsedTime>jump_duration) then
      self:EndKhinhCong()
      return nil
    end
    if(elapsedTime>0.3 and not caster.disjointed)then
      ProjectileManager:ProjectileDodge(caster)
      caster.disjointed = true 
    end
    if(GetGroundHeight(caster:GetOrigin(),caster)>caster:GetOrigin().z and elapsedTime>(jump_duration-0.1))then

      self:EndKhinhCong()
      return nil
    end
    local progress = elapsedTime / jump_duration --percent
  
    -- Interrupted
    if not caster:HasModifier( SETTING_MODIFIER_KHINHCONG_JUMPING ) then
      return nil
    end
    
    -- Calculate potision
    local tempDistance = distance*progress
    local tx = math.cos(angle_from_caster_to_target)*tempDistance
    local ty = math.sin(angle_from_caster_to_target)*tempDistance
   
    local tempHeight = math.sin(math.rad(progress*180))*jump_height

    local newOrigin = casterOrigin+Vector(tx,ty,tempHeight)
    caster:SetAbsOrigin( newOrigin )

    return 0.04
  end, 0 )
end

function skill_khinhcong:EndKhinhCong()
  local caster  = self:GetCaster()
  caster:EmitSound(SETTING_JUMP_END_SOUND_EFFECT)

  
  caster:RemoveModifierByName(SETTING_MODIFIER_KHINHCONG_JUMPING)
  caster:RemoveGesture(SETTING_START_GESTURE)
  local co = caster:GetOrigin()
  local gh = GetGroundHeight(caster:GetOrigin(),caster)
  if(gh<co.z)then
      --cao hon mat dat
      caster:SetOrigin(Vector(co.x,co.y,gh))
    end
  FindClearSpaceForUnit(caster, co, false )

end

function skill_khinhcong:CheckToInterrupt()
  local caster  =self:GetCaster()

  if caster:IsStunned() or caster:IsHexed() or caster:IsFrozen() or caster:IsNightmared() or caster:IsOutOfGame() then
    -- Interrupt the ability

    caster:RemoveModifierByName( SETTING_MODIFIER_KHINHCONG_JUMPING)
  end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------