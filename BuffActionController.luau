--!strict
local RunService = game:GetService("RunService")

local Client = RunService:IsClient()
local Server = RunService:IsServer()

local buffIdCounter = 0


local BAC = {}
BAC.__index = BAC

local Signal = require("./addons/Signal/Signal")

function BAC.new(Player: Player)
    assert(
        (typeof(Player) == "Instance" and Player:IsA("Player"))
            or (typeof(Player) == "table" and Player.UserId ~= nil),
        "BuffActionController.new: Player must be a valid Player instance or a table containing UserId."
    )

    local self = setmetatable({}, BAC)
    
    self.OnBuffApplied = Signal.new()
    self.OnBuffExpired = Signal.new()

    self.IsClient = Client
    self.IsServer = Server

    self.Player = Player

    self.ActiveBuffIds = {}
    self.ActiveBuffByBuff = {}

    return self
end

export type BuffActionController = typeof(BAC.new({UserId = 0} ::any))
type buffId = number
type ConditionIds = string

function BAC:FindBuff(Buff:string): any

    return nil
end

function BAC:GetCondition(Buff:ConditionIds): number?

    return nil
end

local function generateBuffId(): buffId
    buffIdCounter += 1
    return buffIdCounter
end

-- Timelimit in seconds and set to workspace:getservertime() + Given timelimit
function BAC:ApplyBuffs(Buffs: {any}, TimeLimit: number?): buffId
    local buffId = generateBuffId()
    
    return buffId
end

function BAC:RemoveBuff(BuffId:buffId)
    return nil
end

return BAC