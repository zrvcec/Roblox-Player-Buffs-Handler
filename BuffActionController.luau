--!strict
--!nolint LocalShadow

local RunService = game:GetService("RunService")

local Client = RunService:IsClient()
local Server = RunService:IsServer()

local buffIdCounter = 0

local BAC = {}
BAC.__index = BAC

local Signal = require("./addons/Signal/Signal")
local Networker = require("./addons/Networker/Networker")

Networker.init()

local BuffEvent, DirectoryToBuff = Networker.Get("BuffEvent", "RemoteEvent")
local BuffEventKey = DirectoryToBuff.BuffEvent.Keys

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

export type BuffActionController = typeof(BAC.new({UserId = "ccc"} ::any))
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

local function startListeningForBuffs()
        local Events = {
        [BuffEventKey.BuffApplied] = function()
            
        end,

        [BuffEventKey.BuffExpired] = function()
            
        end
    }

    BuffEvent.Event.OnClientEvent:Connect(function(KEY:number, ...:any)
        local Handle = Events[KEY]
        if Handle then
            Handle(...)
        end
    end)
end

if Client then
    startListeningForBuffs()
end

-- Only call this when its definitively getting removed from memory, otherwise system will error
function BAC:Destroy()
    local self = self :: BuffActionController

    pcall(function()
        self.OnBuffApplied:Destroy()
        self.OnBuffApplied = nil
    end)

    pcall(function()
        self.OnBuffExpired:Destroy()
        self.OnBuffExpired = nil
    end)

    table.clear(self :: any)
end

return BAC