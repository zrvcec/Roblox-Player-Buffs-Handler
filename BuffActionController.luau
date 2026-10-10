--!strict

local BAC = {}
BAC.__index = BAC

local Signal = require("./addons/Signal/Signal")

function BAC.new()
    local self = setmetatable({}, BAC)
    
    self.OnBuffApplied = Signal.new()
    self.OnBuffExpired = Signal.new()

    return self
end

export type BuffActionController = typeof(BAC.new())
type buffId = number
type ConditionIds = string

function BAC:FindBuff(Buff:string): any

    return nil
end

function BAC:GetCondition(Buff:ConditionIds): any

    return nil
end

-- Timelimit in seconds and set to workspace:getservertime() + Given timelimit
function BAC:ApplyBuffs(Buffs: {any}, TimeLimit: number?): buffId

    return 0
end

function BAC:RemoveBuff(BuffId:buffId)
    return nil
end

return BAC