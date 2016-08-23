modifier_chiennhan_maamphephach_stack = class({})
require('kem_lib/kem')

if IsServer() then
    function modifier_chiennhan_maamphephach_stack:Update()
        if self:GetDuration() == -1 then
            self:SetDuration(self.kv.replenish_time, true)
            self:StartIntervalThink(self.kv.replenish_time)
        end

        if self:GetStackCount() == 0 then
            self:GetAbility():StartCooldown(self:GetRemainingTime())
        end
    end
   
    function modifier_chiennhan_maamphephach_stack:OnCreated(kv)
        self:SetStackCount(kv.start_count or kv.max_count)
        self.kv = kv

        if kv.start_count and kv.start_count ~= kv.max_count then
            self:Update()
        end
    end
    function modifier_chiennhan_maamphephach_stack:OnRefresh(kv)
        --self:SetStackCount(kv.start_count or kv.max_count)
        self.kv = kv

        if self:GetStackCount() ~= kv.max_count then
            self:Update()
        end
    end
    function modifier_chiennhan_maamphephach_stack:DeclareFunctions()
        local funcs = {
            MODIFIER_EVENT_ON_ABILITY_EXECUTED
        }

        return funcs
    end

    function modifier_chiennhan_maamphephach_stack:OnAbilityExecuted(params)
        if params.unit == self:GetParent() then
            local ability = params.ability

            if params.ability == self:GetAbility() then
               
                  self:DecrementStackCount()
                  self:Update()
                
               
                
            end
        end

        return 0
    end

    function modifier_chiennhan_maamphephach_stack:OnIntervalThink()
        local stacks = self:GetStackCount()

        if stacks < self.kv.max_count then
            self:SetDuration(self.kv.replenish_time, true)
            self:IncrementStackCount()

            if stacks == self.kv.max_count - 1 then
                self:SetDuration(-1, true)
                self:StartIntervalThink(-1)
            end
        end
    end
end
 function modifier_chiennhan_maamphephach_stack:RemoveOnDeath()
        return false
    end
function modifier_chiennhan_maamphephach_stack:DestroyOnExpire()
    return false
end

function modifier_chiennhan_maamphephach_stack:IsPurgable()
    return false
end