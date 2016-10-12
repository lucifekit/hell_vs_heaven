modifier_angry = class({})
function modifier_angry:GetTexture()
  return "queenofpain_scream_of_pain"
end
if IsServer() then
    function modifier_angry:Update()
        self:StartIntervalThink(self.kv.replenish_time)
    end
   
    function modifier_angry:OnCreated(kv)
        self.kv = kv
        if kv.start_count and kv.start_count ~= kv.max_count then
            self:Update()
            self.ability_list = {}
            
            for i = 0,11 do
              local tempAbility = self:GetParent():GetAbilityByIndex(i) 
              if(tempAbility.IsAngryAbility)then
                table.insert(self.ability_list,tempAbility)
              end
              
            end
        end
    end

    function modifier_angry:DeclareFunctions()
        local funcs = {
            MODIFIER_EVENT_ON_TAKEDAMAGE,
            MODIFIER_EVENT_ON_ABILITY_EXECUTED
        }
        return funcs
    end
    function modifier_angry:OnAbilityExecuted(params)
        if params.unit == self:GetParent() then
            local ability = params.ability

            if ability.IsAngryAbility then
                self:SetStackCount(math.max(0,self:GetStackCount()-50))                
            end
        end

        return 0
    end
    function modifier_angry:OnTakeDamage(params)
      if(IsServer())then
        local caster = self:GetParent()
       
        if((caster==params.unit or caster==params.attacker)and params.damage>0)then
          --deal damage//take damage
          local first_time = false
          if(self.last_damage==nil)then
            self.last_damage = GameRules:GetGameTime()
            
             
            first_time = true
          end
          local now_time = GameRules:GetGameTime()
          local sameTarget = false
          
          local canAddStack = true
          if(not first_time)then
            if(caster==params.unit)then
              if(self.last_unit == params.attacker)then
                sameTarget = true
              end
            else
              if(self.last_unit == params.unit)then
                sameTarget = true
              end
            end
            
            
            if(sameTarget)then
              if(now_time-self.last_damage<0.07)then
                --print("ko phai lan dau, cung muc tieu")
                canAddStack=false
              end            
            end
          end
          --neu la angry ability thi ko add
          if(params.inflictor)then
            if(params.inflictor.IsAngryAbility)then
              if(caster==params.attacker)then
                --neu la no chieu thi ko add stack
                canAddStack = false
              end
              
            end
          end
          
          
          if(caster==params.unit)then
            self.last_unit = params.attacker
          else
            self.last_unit = params.unit
          end
          
          if(canAddStack)then
            --add
            self.last_damage = GameRules:GetGameTime()
            
            
            if(self:GetStackCount()<self.kv.max_count)then
            
              self:IncrementStackCount()
              self:IncrementStackCount()
              if(IsInToolsMode())then
                self:IncrementStackCount()
                self:IncrementStackCount()
                self:IncrementStackCount()
                self:IncrementStackCount()
              end
              if(caster==params.unit and caster:HasModifier("modifier_defense"))then
                self:IncrementStackCount()
                self:IncrementStackCount()   
                 if(IsInToolsMode())then
                  self:IncrementStackCount()
                  self:IncrementStackCount()
                  self:IncrementStackCount()
                  self:IncrementStackCount()
                end         
              end
            end
            
            if(self:GetStackCount()>50)then
              if #self.ability_list>0 then
                for i = 1,#self.ability_list do
                  self.ability_list[i]:EndCooldown()
                end
              end
            end  
          end
                  
        end
      end
    end
    function modifier_angry:OnIntervalThink()
        local stacks = self:GetStackCount()

        if stacks > 0  then
            --self:SetDuration(self.kv.replenish_time, true)
            if(self.last_damage)then
              local now_time = GameRules:GetGameTime()
              if(now_time-self.last_damage>5)then
                self:DecrementStackCount()
                if(now_time-self.last_damage>20)then
                  --giam 10 diem lien tiep thi ve 0 luon
                  self:SetStackCount(0)
                end  
              end
            end
                        
        end
        if stacks > 50 then
          if #self.ability_list>0 then
            for i = 1,#self.ability_list do
              self.ability_list[i]:EndCooldown()
            end
          end
        else
          if #self.ability_list>0 then
            for i = 1,#self.ability_list do
              if(self.ability_list[i]:GetLevel()>1)then
                self.ability_list[i]:StartCooldown(999)
              end
              
            end
          end
        end
    end
end
 function modifier_angry:RemoveOnDeath()
        return false
    end
function modifier_angry:DestroyOnExpire()
    return false
end

function modifier_angry:IsPurgable()
    return false
end